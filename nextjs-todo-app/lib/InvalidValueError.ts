export default class InvalidValueError extends Error {
  constructor(name: string, value: unknown) {
    let valueText: string;
    if (typeof value === 'undefined') valueText = 'undefined';
    else if (value === null) valueText = 'null';
    else if (typeof value === 'object') valueText = JSON.stringify(value);
    else if (typeof value === 'number' && isNaN(value)) valueText = 'NaN';
    else valueText = JSON.stringify(value);
    super(`${name} is invalid: ${valueText}`);
  }
}
