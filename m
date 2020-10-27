Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DDE29A9A4
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Oct 2020 11:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898256AbgJ0Kad (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 27 Oct 2020 06:30:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34762 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2898254AbgJ0KaY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 27 Oct 2020 06:30:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id i1so1295433wro.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 27 Oct 2020 03:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=6mFWuGj/JmMxu1KTtHzOsJidTE1bsxOrKQvtD9BTkBI=;
        b=g5K1SpgOVcDObO0kscMkAkrR0ms1PJv65w2H74nwoAxKm6V+7QkNwcHH83gE8vHn6g
         TxxQA89TvCfWz69HCyZYDUzcVpGVf3FeVxATGPnCaobRggoMxHjUQlbglB8F3pEXmRFQ
         QIe2ZX06TG0Ua+yy5DBrb3aGpiBpQkFirsnKJ0Ka2hjvjyRcK8yQacGDzv6TK89ORJIw
         dQFC/gYiy+BHQECEtfD9CV0jVrjXLQgGjukTCK95+WGkoecGxEPPo4cklcb1djnM/Ylj
         8xKT5uuZTfmugmsuoSAkM3JtJeBzaYfeU6JeRZsZi0BMfxY2hYrppz0FGWk3hK8sIhH+
         fcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6mFWuGj/JmMxu1KTtHzOsJidTE1bsxOrKQvtD9BTkBI=;
        b=azyZeZEp1Jb1uRWFNfVt/huI7BlYynKb3d+UdTkL8bpu32wzfwJWejrk/QV+r+MJRH
         gxor2q5jdVlHNQG4wbF4s7hcPSWC0zDn5WFr5mnLajfENDasIt6WzWnmYrl3KububNnZ
         2lilWvMiL3Bo6wXpjJhLfMiaEP0iOjNI00DzPZRsenLmcaM8sWFfJHo8se8vgq8eEoC8
         vwSzracN9vL+OVFhIm3sNfKgsvbsj2C8mA+jtj4qAXO9ADlOqMq0eGt8eDchxki3b4J6
         Ipi2xrN01ZHBI8lHCJpdedkFEUytRi2euR3aZvzBKBOx6AgPeQfuf36U1R04oVMf1qAv
         R3tQ==
X-Gm-Message-State: AOAM530y95V7xzPYk4l5B68KqZfHtGF/oOogR5Mr5mcXFbn8O4YvyKJf
        ZrGqIWuq+39A0/nT5i1L3YM=
X-Google-Smtp-Source: ABdhPJxbaD5/WXJ+oQW7kRjuBWvE/jqE4QionsdQ+u4FalyFM7LnMFLwMZkQliDA3O/r8ewNeRKJZQ==
X-Received: by 2002:adf:ec0e:: with SMTP id x14mr2193302wrn.204.1603794621635;
        Tue, 27 Oct 2020 03:30:21 -0700 (PDT)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id j9sm1445671wrp.59.2020.10.27.03.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 03:30:20 -0700 (PDT)
Message-ID: <035c541ee436febb5c32df4af469c06189c13e20.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH] override CFLAGS too
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Tue, 27 Oct 2020 10:30:20 +0000
In-Reply-To: <20201026221019.GB185792@sol.localdomain>
References: <20201026204831.3337360-1-luca.boccassi@gmail.com>
         <20201026221019.GB185792@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2020-10-26 at 15:10 -0700, Eric Biggers wrote:
> [+Jes Sorensen]
> 
> On Mon, Oct 26, 2020 at 08:48:31PM +0000, luca.boccassi@gmail.com wrote:
> > From: Romain Perier <romain.perier@gmail.com>
> > 
> > Currently, CFLAGS are defined by default. It has to effect to define its
> > c-compiler options only when the variable is not defined on the cmdline
> > by the user, it is not possible to merge or mix both, while it could
> > be interesting for using the app warning cflags or the pkg-config
> > cflags, while using the distributor flags. Most distributions packages
> > use their own compilation flags, typically for hardening purpose but not
> > only. This fixes the issue by using the override keyword.
> > 
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > ---
> > Currently used in Debian, were we want to append context-specific
> > compiler flags (eg: for compiler hardening options) without
> > removing the default flags
> > 
> >  Makefile | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 6c6c8c9..5020cac 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -35,14 +35,15 @@
> >  cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
> >  	      then echo $(1); fi)
> >  
> > -CFLAGS ?= -O2 -Wall -Wundef					\
> > +override CFLAGS := -O2 -Wall -Wundef				\
> >  	$(call cc-option,-Wdeclaration-after-statement)		\
> >  	$(call cc-option,-Wimplicit-fallthrough)		\
> >  	$(call cc-option,-Wmissing-field-initializers)		\
> >  	$(call cc-option,-Wmissing-prototypes)			\
> >  	$(call cc-option,-Wstrict-prototypes)			\
> >  	$(call cc-option,-Wunused-parameter)			\
> > -	$(call cc-option,-Wvla)
> > +	$(call cc-option,-Wvla)					\
> > +	$(CFLAGS)
> >  
> >  override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> 
> I had it like this originally, but Jes requested that it be changed to the
> current way for rpm packaging.  See the thread:
> https://lkml.kernel.org/linux-fscrypt/20200515205649.1670512-3-Jes.Sorensen@gmail.com/T/#u
> 
> Can we come to an agreement on one way to do it?
> 
> To me, the approach with 'override' makes more sense.  The only non-warning
> option is -O2, and if someone doesn't want that, they can just specify
> CFLAGS=-O0 and it will override -O2 (since the last option "wins").
> 
> Jes, can you explain why that way doesn't work with rpm?

I see - I'm pretty sure what we want to override is the optimization
flag (and any other flag that affect the binary, eg: debugging
symbols), but not the other flags that you set (eg: warnings).

So, how about this v2:

From b48d09b1868cfa50b2cd61eec2951f722943e421 Mon Sep 17 00:00:00 2001
From: Romain Perier <romain.perier@gmail.com>
Date: Sun, 19 Apr 2020 09:24:09 +0200
Subject: [PATCH] override CFLAGS too

Currently, CFLAGS are defined by default. It has to effect to define its
c-compiler options only when the variable is not defined on the cmdline
by the user, it is not possible to merge or mix both, while it could
be interesting for using the app warning cflags or the pkg-config
cflags, while using the distributor flags. Most distributions packages
use their own compilation flags, typically for hardening purpose but not
only. This fixes the issue by using the override keyword.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 Makefile | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 6c6c8c9..82abfe9 100644
--- a/Makefile
+++ b/Makefile
@@ -35,14 +35,19 @@
 cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
 	      then echo $(1); fi)
 
-CFLAGS ?= -O2 -Wall -Wundef					\
+# Flags that callers can override
+CFLAGS ?= -O2
+
+# Flags that we always want to use
+INTERNAL_CFLAGS := -Wall -Wundef				\
 	$(call cc-option,-Wdeclaration-after-statement)		\
 	$(call cc-option,-Wimplicit-fallthrough)		\
 	$(call cc-option,-Wmissing-field-initializers)		\
 	$(call cc-option,-Wmissing-prototypes)			\
 	$(call cc-option,-Wstrict-prototypes)			\
 	$(call cc-option,-Wunused-parameter)			\
-	$(call cc-option,-Wvla)
+	$(call cc-option,-Wvla)					\
+	$(CFLAGS)
 
 override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
 
@@ -65,7 +70,7 @@ PKGCONF         ?= pkg-config
 .build-config: FORCE
 	@flags=$$(							\
 		echo 'CC=$(CC)';					\
-		echo 'CFLAGS=$(CFLAGS)';				\
+		echo 'CFLAGS=$(INTERNAL_CFLAGS)';			\
 		echo 'CPPFLAGS=$(CPPFLAGS)';				\
 		echo 'LDFLAGS=$(LDFLAGS)';				\
 		echo 'LDLIBS=$(LDLIBS)';				\
@@ -98,7 +103,7 @@ endif
 #### Library
 
 SOVERSION       := 0
-LIB_CFLAGS      := $(CFLAGS) -fvisibility=hidden
+LIB_CFLAGS      := $(INTERNAL_CFLAGS) -fvisibility=hidden
 LIB_SRC         := $(wildcard lib/*.c)
 LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
 STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
@@ -121,7 +126,7 @@ DEFAULT_TARGETS += libfsverity.a
 # Create shared library
 libfsverity.so.$(SOVERSION):$(SHARED_LIB_OBJ)
 	$(QUIET_CCLD) $(CC) -o $@ -Wl,-soname=$@ -shared $+ \
-		$(CFLAGS) $(LDFLAGS) $(LDLIBS)
+		$(INTERNAL_CFLAGS) $(LDFLAGS) $(LDLIBS)
 
 DEFAULT_TARGETS += libfsverity.so.$(SOVERSION)
 
@@ -160,23 +165,23 @@ TEST_PROGRAMS     := $(TEST_PROG_SRC:programs/%.c=%)
 
 # Compile program object files
 $(ALL_PROG_OBJ): %.o: %.c $(ALL_PROG_HEADERS) .build-config
-	$(QUIET_CC) $(CC) -o $@ -c $(CPPFLAGS) $(CFLAGS) $<
+	$(QUIET_CC) $(CC) -o $@ -c $(CPPFLAGS) $(INTERNAL_CFLAGS) $<
 
 # Link the fsverity program
 ifdef USE_SHARED_LIB
 fsverity: $(FSVERITY_PROG_OBJ) libfsverity.so
 	$(QUIET_CCLD) $(CC) -o $@ $(FSVERITY_PROG_OBJ) \
-		$(CFLAGS) $(LDFLAGS) -L. -lfsverity
+		$(INTERNAL_CFLAGS) $(LDFLAGS) -L. -lfsverity
 else
 fsverity: $(FSVERITY_PROG_OBJ) libfsverity.a
-	$(QUIET_CCLD) $(CC) -o $@ $+ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+	$(QUIET_CCLD) $(CC) -o $@ $+ $(INTERNAL_CFLAGS) $(LDFLAGS) $(LDLIBS)
 endif
 
 DEFAULT_TARGETS += fsverity
 
 # Link the test programs
 $(TEST_PROGRAMS): %: programs/%.o $(PROG_COMMON_OBJ) libfsverity.a
-	$(QUIET_CCLD) $(CC) -o $@ $+ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+	$(QUIET_CCLD) $(CC) -o $@ $+ $(INTERNAL_CFLAGS) $(LDFLAGS) $(LDLIBS)
 
 ##############################################################################
 
-- 
2.20.1


