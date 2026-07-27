# Environments

Environments are capability contracts, not product names. A project may implement them with any hosting, database, CI, or secret-management provider as long as the isolation, data, and approval requirements below are met.

## Default environment model

| Environment | Purpose | Application | Data | Lifetime |
|---|---|---|---|---|
| Local | Developer iteration | Local runtime | Synthetic or developer-owned | Short-lived |
| Preview | One pull request’s complete behavior | Isolated deployment | Approved clone plus synthetic fixtures | Until PR closes |
| QA | Deliberate cross-feature or release validation | Stable, reviewable deployment | Controlled non-production dataset | Resettable |
| Production | Real user traffic | Protected deployment | Real data | Persistent |

## When Preview is required

Preview is **conditional on risk**, not universal. It is required when a change carries a `ui`, `api`, or `database` tag, and for every Track C change. It is not required for Track A, nor for Track B changes that touch none of those tags.

This is a deliberate limit on cost. Requiring an ephemeral deployed environment for every pull request — including a typo fix — makes ephemeral-environment infrastructure a precondition for adopting AIDF at all, and contradicts the framework's own advice to use the lightest process that protects the project. A team without preview infrastructure can still run Tracks A and B fully; they acquire it when they first ship UI, API, or schema work.

Where Preview is not required, the reviewer still needs a way to exercise the change: a build artifact, a local run, or a test that demonstrates the behavior. "Not previewable" is not the same as "not verified".

QA remains optional as a shared environment. It is useful when several approved PRs must be tested together, and it is **disabled by default** in the manifest.

## Environment contract

Each environment must declare:

- URL or access route;
- commit or build identifier;
- database or state source;
- secret scope and rotation owner;
- permitted users and roles;
- allowed outbound integrations;
- data classification and expiry/cleanup policy;
- health check and rollback path.

## Data policy

Projects may clone a production database into non-production only with an explicit data classification decision. The default is to use a controlled clone plus synthetic additions, never an unmanaged copy.

- Remove or mask data prohibited by the project’s privacy policy before broad developer or stakeholder access.
- Use environment-specific credentials; a preview must not reuse production credentials.
- Record the clone source, timestamp, retention period, and data owner.
- Treat seeded credentials, API keys, and test personas as synthetic and non-production.
- Destroy ephemeral state on PR closure; reset QA state before a new test cycle when its baseline matters.

## Environment variables and secrets

Environment variables are configuration, not a substitute for access policy. Separate variables and secret stores by environment, expose secrets only to approved jobs, and never commit local configuration files containing credentials.

The production migration credential should be distinct from the application runtime credential. It may perform schema changes; the application credential should have only the permissions needed to serve the application.

## Promotion rule

Code promotion and data promotion are different actions. Promote an immutable source revision through review and release gates. Apply versioned migration artifacts to the target database. Do not “promote” a preview database into production.
