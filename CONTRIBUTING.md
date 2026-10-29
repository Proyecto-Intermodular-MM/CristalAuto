### Guidelines for Pull Requests

- Use [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) when making pull requests.

- Keep commits within the scope of the feature being changed.

- Before making a pull request ensure all tests pass and there are no analysis errors.

### Formatting Commit Messages

#### Type should be one of the following:

- feat: a new feature
- fix: a bug fix
- docs: documentation only changes
- style: changes that do not affect the meaning of the code
- refactor: a code change that neither fixes a bug nor adds a feature
- perf: a code change that improves performance
- test: adding missing tests or correcting existing tests
- build: changes that affect the build system or external dependencies
- ci: changes to CI configuration files and scripts
- chore: other changes that don't modify src or test files
- revert: reverts a previous commit

Use `<type>(<scope>)!` for breaking changes.

#### Scope is optional, but should be one of the following:

- theme: changes to theming or palette
- ui: changes to UI components or window shell
- assets: changes to fonts or other assets
- deps: changes to dependencies
- ci: changes to the CI pipeline
- lint: changes that only affect formatting or linting

#### Subject line rules:

- Use imperative mood: "add" not "added" nor "adds"
- No dot (.) at the end
- Limit to 72 characters
- No capitalisation in the subject aside from proper nouns

#### Body rules:

- Wrap at 72 characters
- Use imperative mood
- Explain what and why vs. how

