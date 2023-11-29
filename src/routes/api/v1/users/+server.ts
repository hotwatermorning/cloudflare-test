import { drizzle } from 'drizzle-orm/d1';
import { users } from '$db/src/schema';
import { error, type RequestEvent, type RequestHandler } from '@sveltejs/kit';

export const GET: RequestHandler = async ({ request, url, platform }: RequestEvent) => {
  console.log(`${request.method} ${url.pathname}`);

  const DB = platform?.env?.DB;
  if( DB == null ) {
    throw error(503, "Invalid DB");
  }

  const db = drizzle(DB);
  const result = await db.select().from(users).all();
  return Response.json(result);
};
