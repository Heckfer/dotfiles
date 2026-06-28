# Global preferences (all projects)

> These are defaults that apply to any AI coding agent. A repository's own agent-instructions file (`AGENTS.md`, `CLAUDE.md`, or equivalent), or an explicit instruction in the conversation, overrides anything here.

## Function signatures

Avoid optional and default-valued parameters **outside of UI-component construction**. UI components legitimately have many props (Flutter widgets, React/HTML components, etc.), so the rule does **not** apply there.

The mechanical test for the UI exception: a function/constructor is exempt **only if it constructs or returns a UI component** (e.g. a `Widget` subclass constructor, or a function whose return type is a `Widget`). Pure logic, services, mappers, projectors, etc. are **not** exempt even when they live in the presentation layer or are named after UI concepts.

Outside that exception:

- **Default values** → extract to named constants instead of inlining as parameter defaults. Default to **private constants local to the owning class/file** (e.g. `static const _pinBaseDiameter = 32.0;`). Only promote to a shared tokens/constants file when the value is genuinely reused across files.
- **Optional parameters** → decide by whether the argument actually varies across call sites:
  1. **It varies** (sometimes passed, sometimes not) → split into separate functions with descriptive names; the richer one may delegate to the simpler one. Prefer this over one function with optional params.
  2. **It never varies in practice** (always takes the same value) → it isn't really a parameter; delete it and replace with a named constant. Do **not** create a second function for this case — that adds a signature nobody calls. *(Check the real call sites before assuming case 1.)*
- **Required named parameters are always allowed**, everywhere. The objection is to optionality and defaults, not to naming — `({required this.x})` improves call-site readability and carries no default.
- **Exempt machinery**: `copyWith`, `fromJson`-style factories, and equality/serialization helpers are exempt — optionality is intrinsic to their contract.

## No test-only production surface

Don't keep production surface whose only consumer is the test suite. This covers **any** kind of surface: optional/injection parameters, widened visibility, public methods, constructors/factories, feature flags, etc.

**Litmus:** a seam is legitimate only if **production code actually supplies a real (non-default) value through it**. If the only thing that ever varies a parameter — or the only thing that calls a method, or the only reason a member is public — is a test, it exists solely for testing → remove it and test through the real public surface with real values.

- **Legitimate** (keep): dependency injection where production wires the real collaborator and tests wire a fake — both sides use the seam. *(e.g. injecting a DB-backed provider in `main`, a fake in the test.)*
- **Smell** (remove): a parameter production never passes; a parameter only a test ever passes (especially with the same value as the default); a member made public or `@visibleForTesting` purely so a test can reach it.

A test that needs to reach internals is a design signal: extract that logic into its own unit with a genuine public API (it's public because it has a real caller — the extracted unit), rather than widening visibility.

`@visibleForTesting` is permitted only as a last resort when restructuring would be disproportionate — it at least documents intent and is greppable. Reach for extraction first.

Note: testing real behavior through the real public API with real production values is not test-only surface — that's just a good test. The thing to avoid is *production API that exists only to be poked by tests*.

## Git
- **Always merge branches with `--no-ff`** (preserve a merge commit; never fast-forward, never squash). This applies to all projects.
  - Local merges: `git merge --no-ff <branch>`.
  - GitHub PRs via `gh`: use `gh pr merge --merge` (a true merge commit) — NOT `--squash` or `--rebase`.
