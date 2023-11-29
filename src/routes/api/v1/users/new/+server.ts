import { drizzle } from 'drizzle-orm/d1';
import { users } from '$db/src/schema';
import { error, json, type RequestEvent, type RequestHandler } from '@sveltejs/kit';

export const POST: RequestHandler = async ({ request, url, platform }: RequestEvent) => {
  console.log(`${request.method} ${url.pathname}`);

  const j: any = await request.json();
  const DB = platform?.env?.DB;
  if( DB == null ) {
    throw error(503, "Invalid DB");
  }

  const db = drizzle(DB);
  const obj = await db.insert(users).values({name: j["name"], tel: j["tel"]}).returning();
  return json(obj);
};
