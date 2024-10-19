import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async create(data: CreateUserDto) {
    const salt = await bcrypt.genSalt();
    data.password = await bcrypt.hash(data.password, salt);
    try {
      const user = await this.prisma.user.create({
        data,
      });
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { password, ...result } = user;
      return result;
    } catch (error) {
      if (error.code === 'P2002' && error.meta.target === 'User_email_key') {
        throw new ConflictException('E-mail already in use');
      }
      throw error;
    }
  }

  findAll() {
    return this.prisma.user.findMany();
  }

  async findOne(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return user;
  }

  update(id: string, data: UpdateUserDto) {
    return this.prisma.user.update({
      where: { id },
      data,
    });
  }

  async remove(id: string) {
    try {
      return await this.prisma.user.delete({
        where: { id },
      });
    } catch (error) {
      throw new NotFoundException(
        `User with ID ${id} not found. Error: ${error}`,
      );
    }
  }
}
