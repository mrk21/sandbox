# Rails Power BI embed

## Dependencies

- ruby 3.2.2
- rails: 7.0.7.2
- mysql: 8.0
- Node.js
- TypeScript
- webpack
- gems:
  - oauth2
  - simpacker
- npm packages:
  - powerbi-client

## Setup

```sh
# Set your secrets
cp .envrc.sample .envrc
vi .envrc

# Initialize application
docker compose build
docker compose run rails bundle install
docker compose run rails yarn install
docker compose run rails rails db:setup

# Run application
docker compose up
open http://localhost:3000
```

## Usage

```sh
# Run application
docker compose up

# Open application by your browser
open http://localhost:3000

# Launch dev container
devcontainer open .
```

## References

- [Power BI 埋め込み分析のクライアント API | Microsoft Learn](https://learn.microsoft.com/ja-jp/javascript/api/overview/powerbi/)
- [Power BI REST APIs for embedded analytics and automation - Power BI REST API | Microsoft Learn](https://learn.microsoft.com/en-us/rest/api/power-bi/)
- [microsoft/PowerBI-JavaScript: JavaScript library for embedding Power BI into your apps. Check out the docs website and wiki for more information.](https://github.com/microsoft/PowerBI-JavaScript)
- [microsoft/PowerBI-Developer-Samples: A collection of Power BI samples for developer use.](https://github.com/microsoft/PowerBI-Developer-Samples)
- [oauth-xx / oauth2 · GitLab](https://gitlab.com/oauth-xx/oauth2/)
- [RailsからWebpackerを外してpureなwebpack構成にしてみる その2 | Mission-Street.](https://hakozaru.com/posts/purge-webpacker-2)
- [Azure の REST API を curl で操作する - Qiita](https://qiita.com/TsuyoshiUshio@github/items/3d903f071b8cb8305496)
