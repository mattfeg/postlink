import { AuthGuard } from './auth.guard';
import { JwtService } from '@nestjs/jwt';
import { Reflector } from '@nestjs/core';

describe('AuthGuard', () => {
  it('should be defined', () => {
    let jwtService: JwtService;
    let reflector: Reflector;
    expect(new AuthGuard(jwtService, reflector)).toBeDefined();
  });
});
