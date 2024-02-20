import { PrismaClient } from '@prisma/client';

const prismaClient = new PrismaClient();

async function main() {
  const post = await prismaClient.article.upsert({
    where: {
      title: 'First article title',
    },
    update: {},
    create: {
      title: 'First article title',
      body: 'First article created with PrismaORM',
      description: 'Article`s description',
      published: false,
    },
  });

  console.log({ post });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prismaClient.$disconnect();
  });
