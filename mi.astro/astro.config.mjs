import { resolve } from 'path';
import { defineConfig } from 'astro/config';

import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';

import remarkMath from 'remark-math';
import remarkGemoji from 'remark-gemoji';

import rehypeKatex from 'rehype-katex';

export default defineConfig({
  site: 'https://your-site.com/',
  markdown: {
    shikiConfig: {
      theme: 'github-dark',
      transformers: [
        {
          pre(node) {
            node.properties.style = "background-color:#212121;color:#e1e4e8;overflow-x:auto;"
          }
        }
      ]
    },
    rehypePlugins: [rehypeKatex],
    remarkPlugins: [remarkMath, remarkGemoji],
    gfm: true
  },
  integrations: [
    mdx(),
    sitemap()
  ],
  vite: {
    resolve: {
      alias: {
        '@': resolve(import.meta.dirname, './src'),
        '@layouts': resolve(import.meta.dirname, './src/layouts'),
        '@images': resolve(import.meta.dirname, './src/assets/images')
      }
    },
  }
});
