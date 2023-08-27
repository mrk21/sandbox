import * as pbi from "powerbi-client";

// see: https://stackoverflow.com/questions/53558067/powerbi-global-object-not-found-in-typescript
const powerbi = new pbi.service.Service(
  pbi.factories.hpmFactory,
  pbi.factories.wpmpFactory,
  pbi.factories.routerFactory,
);

const models = pbi.models;

async function embed() {
  const reportContainer = window.document.getElementById("report_container");
  if (!reportContainer) throw new Error("report_container not found");

  powerbi.bootstrap(reportContainer, { type: "report" });

  const res = await fetch("/power_bi_reports/embed_data");
  const embedData = await res.json();

  const reportLoadConfig = {
    type: "report",
    tokenType: models.TokenType.Embed,
    accessToken: embedData.accessToken,
    embedUrl: embedData.embedUrl[0].embedUrl,
  } as pbi.service.IComponentEmbedConfiguration;

  const report = powerbi.embed(reportContainer, reportLoadConfig);

  report.off("loaded");
  report.on("loaded", function () {
    console.log("Report load successful");
  });

  report.off("rendered");
  report.on("rendered", function () {
    console.log("Report render successful");
  });

  report.off("error");
  report.on("error", function (event) {
    const errorMsg = event.detail;
    console.error(errorMsg);
  });
}

window.addEventListener("DOMContentLoaded", embed);
