export default {
  testEnvironment: "jsdom",
  transform: {
    "^.+\\.(t|j)sx?$": "@swc/jest",
  },
  moduleNameMapper: {
    "\\.(css)$": "identity-obj-proxy",
    "^.+\\.svg$": "jest-svg-transformer",
  },
  testEnvironmentOptions: {
    customExportConditions: [''],
  },
  setupFilesAfterEnv: ["<rootDir>/jest.setup.js"],
};