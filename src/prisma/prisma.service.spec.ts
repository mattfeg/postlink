import { Test, TestingModule } from '@nestjs/testing';
import { PrismaService } from './prisma.service';
import { PrismaModule } from './prisma.module';

describe('PrismaService', () => {
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PrismaService],
      imports: [PrismaModule.forRoot('.env.test')],
    }).compile();

    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(prisma).toBeDefined();
  });

  it('should call $connect on onModuleInit', async () => {
    const connectSpy = jest.spyOn(prisma, '$connect').mockResolvedValue();

    await prisma.onModuleInit();

    expect(connectSpy).toHaveBeenCalled();
  });

  it('should call $disconnect on onModuleDestroy', async () => {
    const disconnectSpy = jest.spyOn(prisma, '$disconnect').mockResolvedValue();

    await prisma.onModuleDestroy();

    expect(disconnectSpy).toHaveBeenCalled();
  });
});
