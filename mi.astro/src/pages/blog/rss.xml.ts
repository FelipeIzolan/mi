import rss from '@astrojs/rss';
import { site } from "astro:config/server";
import { getCollection } from 'astro:content';

import type { APIContext } from 'astro';

export const href = new URL("/blog/rss.xml", site);
export const title = "rss-title"; // <- must edit!
export const description = "rss-description"; // <- must edit!
export async function GET(ctx: APIContext) {
  let blog = await getCollection('blog');
  return rss({
    title,
    description,
    site: ctx.site as URL,
    items: blog.map(post => ({
      link: `/blog/${post.id}`,
      title: post.data.title,
      description: post.data.description,
      pubDate: new Date(post.data.date)
    }))
  })
}
