const TINYGOROOT = process.env.TINYGOROOT;

export default {
  resolve: {
    alias: {
      '@tinygo/': `${TINYGOROOT}/`,
    },
  },
};
