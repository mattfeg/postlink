import { Prisma } from '@prisma/client';
import { IsEmail, IsString, Length } from 'class-validator';

export class CreateUserDto implements Prisma.UserCreateInput {
  @IsString()
  @Length(2, 50)
  name: string;

  @IsEmail()
  @Length(7, 50)
  email: string;

  @IsString()
  password: string;
}
