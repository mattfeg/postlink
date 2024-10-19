import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from './users.controller';
import { UsersModule } from './users.module';
import { PrismaModule } from '../prisma/prisma.module';

describe('UsersController', () => {
  let controller: UsersController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [UsersModule, PrismaModule.forRoot('.env.test')],
    }).compile();

    controller = module.get<UsersController>(UsersController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
