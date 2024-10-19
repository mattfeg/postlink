import { Module, DynamicModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import * as path from 'path';
import * as fs from 'fs';
import * as dotenv from 'dotenv';

@Module({})
export class PrismaModule {
  static forRoot(envFilePath?: string): DynamicModule {
    const envFile = envFilePath || '.env';

    const filePath = path.resolve(process.cwd(), envFile);
    if (!fs.existsSync(filePath)) {
      throw new Error(`Arquivo .env ${filePath} não encontrado`);
    }

    dotenv.config({ path: filePath });

    return {
      module: PrismaModule,
      imports: [
        ConfigModule.forRoot({
          envFilePath: envFile,
          isGlobal: true,
        }),
      ],
      exports: [ConfigModule],
    };
  }
}
