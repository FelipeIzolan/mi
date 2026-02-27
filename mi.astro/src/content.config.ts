import { glob } from "astro/loaders";
import { defineCollection, z } from "astro:content";

const blog = defineCollection({
  loader: glob({
    pattern: '**/*.{md,mdx}',
    base: './src/content/blog'
  }),
  schema: z.object({
    css: z.object({
      katex: z.boolean().optional()
    }).optional(),
    date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
    title: z.string(),
    description: z.string(),
    author: z.string().optional()
  })
});

export const collections = { blog };
