module.exports = {
    env: {
        es2020: true,
        node: true
    },
    extends: [
        "standard"
    ],
    parserOptions: {
        ecmaVersion: 11,
        sourceType: "module"
    },
    rules: {

        indent: [2, 4, { SwitchCase: 1 }],
        quotes: [2, "double"],
        semi: ["error", "always"],
        camelcase: "off",
        "space-before-function-paren": ["error", "never"]
    }
};
