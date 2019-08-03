export type ActionBase = {
    type: string;
    payload?: any;
    error?: any;
};

export type ActionTreeBase = {
    [key: string]: ActionBase;
};

export type Actions<T extends ActionTreeBase | ActionTreeBase[]> =
    T extends ActionTreeBase ? T[keyof T] :
        T extends ActionTreeBase[] ? { [K in keyof T]: T[K][keyof T[K]] }[number] :
            never;
