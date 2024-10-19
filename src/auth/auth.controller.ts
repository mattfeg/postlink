import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthGuard } from './auth.guard';
import { SkipAuth } from '../SkipAuth/SkipAuth.decorator';

@UseGuards(AuthGuard)
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @HttpCode(HttpStatus.OK)
  @SkipAuth()
  @Post('login')
  signIn(@Body() signInDto: Record<string, never>) {
    return this.authService.signIn(signInDto.email, signInDto.password);
  }
}
