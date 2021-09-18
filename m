Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863664106BD
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Sep 2021 15:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbhIRNWh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Sep 2021 09:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbhIRNWg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Sep 2021 09:22:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAEAC061574
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Sep 2021 06:21:12 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id n10so40152428eda.10
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Sep 2021 06:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=R5s+0PzRfCRvI7BU9w40+JRap7VXUhxVmK0OXihQUp8=;
        b=eZWnU1qKYOa6NZZUDsL+6/D/mVvNdmqOvflhE7rbz5V8vE9mJNFlHdOCQrzTE6x3Gg
         VYXIF1PmTyik/CXzRoRZRw8RBr++mi0vVB0x4bXEkyFn7y3Nyb6+wcj+faNePe8xeYAY
         3itSzR944qr38ihycMlKUMSIyfPwpzgdwbjEvjDJ7xu9CilAA1AnnPoB4v4Gu+tgX6Q1
         bFMvgSiE3IXTK9gjKJn/Is9L30sjBsvZ40RGS3V4AL0GxmgBqU7ViKEFaAyvvm0bd6Zy
         AFNEK0EvV61JWsggbrIFcr1JdKg+psO1M+ddLrbnb3ew5bIgMQek/617ljeie283/e2+
         u7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=R5s+0PzRfCRvI7BU9w40+JRap7VXUhxVmK0OXihQUp8=;
        b=mWKch27obHh3dMA5ts4PHNAZnbfiECkREQMVSywilv5v/+0D2jEWY6ZmvCL1Pk4agT
         r+MKxAMa2mo465VMuG3slUGm1QithXsk1zpYZmbvuFVMEyJoTbOeZEZDil5qEewMIKVF
         1KzVQQUbIPi5KjBCC8/tPWvg/z4lRRdOW3ZIX5cYQnCTxUuvWO+OBH0PQZoKEwIDiMyI
         o4douFY93SrDUVrD+vQhKkUGRJb7P8nLYoyNPsb4rJ1lcOFngqVvuvFdaSx/s3vzKUqf
         yJjFY3sqW/r57STNGucpHHYW/CYresc95Y1AFqmRF0HoYmfXU1epk4GzU1MX4NNEl7aZ
         9vIg==
X-Gm-Message-State: AOAM532D0KXhkGnhqpHIkykCmhsMeKXxv2OCs7noTgZXDcdusWonjajO
        NUeaKQ8VfXrVF/uBAPJSicYWdeJygdQhekdV+xgDiav70C8=
X-Google-Smtp-Source: ABdhPJyg7H13/vImddTxTPpCNr2elVlmEhAUmVI+UPWE6gBX2CWtuYWX8bjbewoQnINsyF+hZhNBWTOmpVJ8HaesFEA=
X-Received: by 2002:a05:6402:648:: with SMTP id u8mr18899153edx.394.1631971270608;
 Sat, 18 Sep 2021 06:21:10 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date:   Sat, 18 Sep 2021 14:20:45 +0100
Message-ID: <CABB28CwFNRhjgrT7NL6xqnasFQRJwhHZ4F0Xrd2XO-AZEyRBHQ@mail.gmail.com>
Subject: 1.4: test suite does not build
To:     linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

Looks like it some issue with test suite because it does not link correctly

+ cd fsverity-utils-1.4
+ CFLAGS=3D'-O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections'
+ CXXFLAGS=3D'-O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections'
+ FFLAGS=3D'-O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -I/usr/lib64/gfortran/modules'
+ FCFLAGS=3D'-O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -I/usr/lib64/gfortran/modules'
+ LDFLAGS=3D'-Wl,-z,relro -Wl,--as-needed -Wl,--gc-sections -Wl,-z,now
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-ld'
+ CC=3D/usr/bin/gcc
+ CXX=3D/usr/bin/g++
+ FC=3D/usr/bin/gfortran
+ AR=3D/usr/bin/gcc-ar
+ NM=3D/usr/bin/gcc-nm
+ RANLIB=3D/usr/bin/gcc-ranlib
+ export CFLAGS CXXFLAGS FFLAGS FCFLAGS LDFLAGS CC CXX FC AR NM RANLIB
+ /usr/bin/make -O -j48 V=3D1 VERBOSE=3D1 check
Rebuilding due to new settings
/usr/bin/gcc -o lib/enable.o -c -Iinclude -D_FILE_OFFSET_BITS=3D64
-D_GNU_SOURCE  -Wall -Wundef -Wdeclaration-after-statement
-Wimplicit-fallthrough -Wmissing-field-initializers
-Wmissing-prototypes -Wstrict-prototypes -Wunused-parameter -Wvla -O2
-g -grecord-gcc-switches -pipe -Wall -Werror=3Dformat-security
-Wp,-D_FORTIFY_SOURCE=3D2 -Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -fvisibility=3Dhidden lib/enable.c
/usr/bin/gcc -o programs/test_hash_algs.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/test_hash_algs.c
/usr/bin/gcc -o programs/test_sign_digest.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/test_sign_digest.c
/usr/bin/gcc -o programs/cmd_measure.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/cmd_measure.c
/usr/bin/gcc -o programs/cmd_enable.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/cmd_enable.c
/usr/bin/gcc -o programs/cmd_sign.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/cmd_sign.c
/usr/bin/gcc -o programs/cmd_digest.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/cmd_digest.c
/usr/bin/gcc -o lib/utils.o -c -Iinclude -D_FILE_OFFSET_BITS=3D64
-D_GNU_SOURCE  -Wall -Wundef -Wdeclaration-after-statement
-Wimplicit-fallthrough -Wmissing-field-initializers
-Wmissing-prototypes -Wstrict-prototypes -Wunused-parameter -Wvla -O2
-g -grecord-gcc-switches -pipe -Wall -Werror=3Dformat-security
-Wp,-D_FORTIFY_SOURCE=3D2 -Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -fvisibility=3Dhidden lib/utils.c
/usr/bin/gcc -o programs/cmd_dump_metadata.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/cmd_dump_metadata.c
/usr/bin/gcc -o programs/fsverity.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/fsverity.c
/usr/bin/gcc -o lib/hash_algs.o -c -Iinclude -D_FILE_OFFSET_BITS=3D64
-D_GNU_SOURCE  -Wall -Wundef -Wdeclaration-after-statement
-Wimplicit-fallthrough -Wmissing-field-initializers
-Wmissing-prototypes -Wstrict-prototypes -Wunused-parameter -Wvla -O2
-g -grecord-gcc-switches -pipe -Wall -Werror=3Dformat-security
-Wp,-D_FORTIFY_SOURCE=3D2 -Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -fvisibility=3Dhidden lib/hash_algs.c
/usr/bin/gcc -o lib/compute_digest.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -fvisibility=3Dhidden lib/compute_digest.c
/usr/bin/gcc -o programs/utils.o -c -Iinclude -D_FILE_OFFSET_BITS=3D64
-D_GNU_SOURCE  -Wall -Wundef -Wdeclaration-after-statement
-Wimplicit-fallthrough -Wmissing-field-initializers
-Wmissing-prototypes -Wstrict-prototypes -Wunused-parameter -Wvla -O2
-g -grecord-gcc-switches -pipe -Wall -Werror=3Dformat-security
-Wp,-D_FORTIFY_SOURCE=3D2 -Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/utils.c
/usr/bin/gcc -o programs/test_compute_digest.o -c -Iinclude
-D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE  -Wall -Wundef
-Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections programs/test_compute_digest.c
/usr/bin/gcc -o lib/sign_digest.o -c -Iinclude -D_FILE_OFFSET_BITS=3D64
-D_GNU_SOURCE  -Wall -Wundef -Wdeclaration-after-statement
-Wimplicit-fallthrough -Wmissing-field-initializers
-Wmissing-prototypes -Wstrict-prototypes -Wunused-parameter -Wvla -O2
-g -grecord-gcc-switches -pipe -Wall -Werror=3Dformat-security
-Wp,-D_FORTIFY_SOURCE=3D2 -Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -fvisibility=3Dhidden lib/sign_digest.c
lib/sign_digest.c: In function 'load_pkcs11_private_key':
lib/sign_digest.c:351:9: warning: 'ENGINE_by_id' is deprecated: Since
OpenSSL 3.0 [-Wdeprecated-declarations]
  351 |         engine =3D ENGINE_by_id("dynamic");
      |         ^~~~~~
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:336:31: note: declared here
  336 | OSSL_DEPRECATEDIN_3_0 ENGINE *ENGINE_by_id(const char *id);
      |                               ^~~~~~~~~~~~
lib/sign_digest.c:356:9: warning: 'ENGINE_ctrl_cmd_string' is
deprecated: Since OpenSSL 3.0 [-Wdeprecated-declarations]
  356 |         if (!ENGINE_ctrl_cmd_string(engine, "SO_PATH",
      |         ^~
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:479:5: note: declared here
  479 | int ENGINE_ctrl_cmd_string(ENGINE *e, const char *cmd_name,
const char *arg,
      |     ^~~~~~~~~~~~~~~~~~~~~~
lib/sign_digest.c:358:13: warning: 'ENGINE_ctrl_cmd_string' is
deprecated: Since OpenSSL 3.0 [-Wdeprecated-declarations]
  358 |             !ENGINE_ctrl_cmd_string(engine, "ID", "pkcs11", 0) ||
      |             ^
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:479:5: note: declared here
  479 | int ENGINE_ctrl_cmd_string(ENGINE *e, const char *cmd_name,
const char *arg,
      |     ^~~~~~~~~~~~~~~~~~~~~~
lib/sign_digest.c:359:13: warning: 'ENGINE_ctrl_cmd_string' is
deprecated: Since OpenSSL 3.0 [-Wdeprecated-declarations]
  359 |             !ENGINE_ctrl_cmd_string(engine, "LIST_ADD", "1", 0) ||
      |             ^
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:479:5: note: declared here
  479 | int ENGINE_ctrl_cmd_string(ENGINE *e, const char *cmd_name,
const char *arg,
      |     ^~~~~~~~~~~~~~~~~~~~~~
lib/sign_digest.c:360:13: warning: 'ENGINE_ctrl_cmd_string' is
deprecated: Since OpenSSL 3.0 [-Wdeprecated-declarations]
  360 |             !ENGINE_ctrl_cmd_string(engine, "LOAD", NULL, 0) ||
      |             ^
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:479:5: note: declared here
  479 | int ENGINE_ctrl_cmd_string(ENGINE *e, const char *cmd_name,
const char *arg,
      |     ^~~~~~~~~~~~~~~~~~~~~~
lib/sign_digest.c:361:13: warning: 'ENGINE_ctrl_cmd_string' is
deprecated: Since OpenSSL 3.0 [-Wdeprecated-declarations]
  361 |             !ENGINE_ctrl_cmd_string(engine, "MODULE_PATH",
      |             ^
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:479:5: note: declared here
  479 | int ENGINE_ctrl_cmd_string(ENGINE *e, const char *cmd_name,
const char *arg,
      |     ^~~~~~~~~~~~~~~~~~~~~~
lib/sign_digest.c:363:13: warning: 'ENGINE_init' is deprecated: Since
OpenSSL 3.0 [-Wdeprecated-declarations]
  363 |             !ENGINE_init(engine)) {
      |             ^
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:620:27: note: declared here
  620 | OSSL_DEPRECATEDIN_3_0 int ENGINE_init(ENGINE *e);
      |                           ^~~~~~~~~~~
lib/sign_digest.c:365:17: warning: 'ENGINE_free' is deprecated: Since
OpenSSL 3.0 [-Wdeprecated-declarations]
  365 |                 ENGINE_free(engine);
      |                 ^~~~~~~~~~~
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:493:27: note: declared here
  493 | OSSL_DEPRECATEDIN_3_0 int ENGINE_free(ENGINE *e);
      |                           ^~~~~~~~~~~
lib/sign_digest.c:368:9: warning: 'ENGINE_load_private_key' is
deprecated: Since OpenSSL 3.0 [-Wdeprecated-declarations]
  368 |         *pkey_ret =3D ENGINE_load_private_key(engine,
sig_params->pkcs11_keyid,
      |         ^
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:638:11: note: declared here
  638 | EVP_PKEY *ENGINE_load_private_key(ENGINE *e, const char *key_id,
      |           ^~~~~~~~~~~~~~~~~~~~~~~
lib/sign_digest.c:370:9: warning: 'ENGINE_finish' is deprecated: Since
OpenSSL 3.0 [-Wdeprecated-declarations]
  370 |         ENGINE_finish(engine);
      |         ^~~~~~~~~~~~~
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:628:27: note: declared here
  628 | OSSL_DEPRECATEDIN_3_0 int ENGINE_finish(ENGINE *e);
      |                           ^~~~~~~~~~~~~
lib/sign_digest.c:371:9: warning: 'ENGINE_free' is deprecated: Since
OpenSSL 3.0 [-Wdeprecated-declarations]
  371 |         ENGINE_free(engine);
      |         ^~~~~~~~~~~
In file included from lib/sign_digest.c:23:
/usr/include/openssl/engine.h:493:27: note: declared here
  493 | OSSL_DEPRECATEDIN_3_0 int ENGINE_free(ENGINE *e);
      |                           ^~~~~~~~~~~
/usr/bin/gcc-ar cr libfsverity.a lib/compute_digest.o lib/enable.o
lib/hash_algs.o lib/sign_digest.o lib/utils.o
/usr/bin/gcc -o test_hash_algs programs/test_hash_algs.o
programs/utils.o -Wall -Wundef -Wdeclaration-after-statement
-Wimplicit-fallthrough -Wmissing-field-initializers
-Wmissing-prototypes -Wstrict-prototypes -Wunused-parameter -Wvla -O2
-g -grecord-gcc-switches -pipe -Wall -Werror=3Dformat-security
-Wp,-D_FORTIFY_SOURCE=3D2 -Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -Wl,-z,relro -Wl,--as-needed -Wl,--gc-sections
-Wl,-z,now -specs=3D/usr/lib/rpm/redhat/redhat-hardened-ld -lcrypto
/usr/bin/ld: programs/test_hash_algs.o: in function `main':
/home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test_hash_algs.c:=
21:
undefined reference to `libfsverity_get_digest_size'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:22:
undefined reference to `libfsverity_get_hash_name'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:23:
undefined reference to `libfsverity_find_hash_alg_by_name'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:24:
undefined reference to `libfsverity_find_hash_alg_by_name'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:26:
undefined reference to `libfsverity_get_digest_size'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:27:
undefined reference to `libfsverity_get_hash_name'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:29:
undefined reference to `libfsverity_get_digest_size'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:31:
undefined reference to `libfsverity_get_hash_name'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:33:
undefined reference to `libfsverity_find_hash_alg_by_name'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:36:
undefined reference to `libfsverity_get_digest_size'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:38:
undefined reference to `libfsverity_get_hash_name'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_hash_algs.c:40:
undefined reference to `libfsverity_find_hash_alg_by_name'
/usr/bin/ld: programs/utils.o: in function `install_libfsverity_error_handl=
er':
/home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/utils.c:102:
undefined reference to `libfsverity_set_error_callback'
collect2: error: ld returned 1 exit status
make: *** [Makefile:194: test_hash_algs] Error 1
make: *** Waiting for unfinished jobs....
/usr/bin/gcc -o test_sign_digest programs/test_sign_digest.o
programs/utils.o -Wall -Wundef -Wdeclaration-after-statement
-Wimplicit-fallthrough -Wmissing-field-initializers
-Wmissing-prototypes -Wstrict-prototypes -Wunused-parameter -Wvla -O2
-g -grecord-gcc-switches -pipe -Wall -Werror=3Dformat-security
-Wp,-D_FORTIFY_SOURCE=3D2 -Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -Wl,-z,relro -Wl,--as-needed -Wl,--gc-sections
-Wl,-z,now -specs=3D/usr/lib/rpm/redhat/redhat-hardened-ld -lcrypto
/usr/bin/ld: programs/test_sign_digest.o: in function `main':
/home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test_sign_digest.=
c:41:
undefined reference to `libfsverity_sign_digest'
/usr/bin/ld: programs/utils.o: in function `install_libfsverity_error_handl=
er':
/home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/utils.c:102:
undefined reference to `libfsverity_set_error_callback'
collect2: error: ld returned 1 exit status
make: *** [Makefile:194: test_sign_digest] Error 1
/usr/bin/gcc -o test_compute_digest programs/test_compute_digest.o
programs/utils.o -Wall -Wundef -Wdeclaration-after-statement
-Wimplicit-fallthrough -Wmissing-field-initializers
-Wmissing-prototypes -Wstrict-prototypes -Wunused-parameter -Wvla -O2
-g -grecord-gcc-switches -pipe -Wall -Werror=3Dformat-security
-Wp,-D_FORTIFY_SOURCE=3D2 -Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -Wl,-z,relro -Wl,--as-needed -Wl,--gc-sections
-Wl,-z,now -specs=3D/usr/lib/rpm/redhat/redhat-hardened-ld -lcrypto
/usr/bin/ld: programs/test_compute_digest.o: in function `main':
/home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test_compute_dige=
st.c:419:
undefined reference to `libfsverity_compute_digest'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_compute_digest.c:423:
undefined reference to `libfsverity_get_digest_size'
/usr/bin/ld: programs/test_compute_digest.o: in function `fix_digest_and_pr=
int':
/home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test_compute_dige=
st.c:165:
undefined reference to `libfsverity_get_hash_name'
/usr/bin/ld: programs/test_compute_digest.o: in function `test_invalid_para=
ms':
/home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test_compute_dige=
st.c:202:
undefined reference to `libfsverity_set_error_callback'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_compute_digest.c:204:
undefined reference to `libfsverity_compute_digest'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_compute_digest.c:210:
undefined reference to `libfsverity_compute_digest'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_compute_digest.c:211:
undefined reference to `libfsverity_compute_digest'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_compute_digest.c:212:
undefined reference to `libfsverity_compute_digest'
/usr/bin/ld: /home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/test=
_compute_digest.c:217:
undefined reference to `libfsverity_compute_digest'
/usr/bin/ld: programs/test_compute_digest.o:/home/tkloczko/rpmbuild/BUILD/f=
sverity-utils-1.4/programs/test_compute_digest.c:219:
more undefined references to `libfsverity_compute_digest' follow
/usr/bin/ld: programs/utils.o: in function `install_libfsverity_error_handl=
er':
/home/tkloczko/rpmbuild/BUILD/fsverity-utils-1.4/programs/utils.c:102:
undefined reference to `libfsverity_set_error_callback'
collect2: error: ld returned 1 exit status
make: *** [Makefile:194: test_compute_digest] Error 1
/usr/bin/gcc -o fsverity programs/utils.o programs/cmd_digest.o
programs/cmd_sign.o programs/fsverity.o programs/cmd_dump_metadata.o
programs/cmd_enable.o programs/cmd_measure.o libfsverity.a -Wall
-Wundef -Wdeclaration-after-statement -Wimplicit-fallthrough
-Wmissing-field-initializers -Wmissing-prototypes -Wstrict-prototypes
-Wunused-parameter -Wvla -O2 -g -grecord-gcc-switches -pipe -Wall
-Werror=3Dformat-security -Wp,-D_FORTIFY_SOURCE=3D2
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64 -mtune=3Dgeneric -fasynchronous-unwind-tables
-fstack-clash-protection -fcf-protection -fdata-sections
-ffunction-sections -Wl,-z,relro -Wl,--as-needed -Wl,--gc-sections
-Wl,-z,now -specs=3D/usr/lib/rpm/redhat/redhat-hardened-ld -lcrypto

BTW I have two questions:
1) Is it possible to move the git repo to github or gitlab to provide
a better communication platform? (tickets and github provides email
notifications when a new release is tagged) or at least organise a
live mirror with enabled issue tracker?
2) Would you accept a patch providing build fsverity-utils build
framework using GNU autotools or meson?

kloczek
--=20
Tomasz K=C5=82oczko | LinkedIn: http://lnkd.in/FXPWxH
