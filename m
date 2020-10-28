Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACC729E182
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Oct 2020 03:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgJ2CBj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Oct 2020 22:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgJ1Vt2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Oct 2020 17:49:28 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F511C0613D3
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Oct 2020 14:49:28 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id f9so734503lfq.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Oct 2020 14:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=0OrNbu5bMQl+pauFxjSKVVG7fr+LFMir3savpzE4/1o=;
        b=Uml3wt2VrWFRbg+1uoekMp4QQ9Fe/YkNbTxOTomp5fM1FwwlBwtj7L0/1rI5mL79vS
         GqddFi+mBB8n0BTjT4ZK9jA/0pbN1XXBF/NJ48X1stiOGl1ixioVk0HREy3um1cOTqOE
         Z1tuyNdr975g8SDV2avpsTjQWMHLIiRPwVjB2Vk4xEa4xkWOVBQfkDnzOfXRm2mXj++a
         QbRKr2BAA2dn+y9s5wMz66hcMIVpC1p7Tvd82cstXYR1hzzKI3GhJbVU9GCfwIzaoFch
         3MFelvBThfyiIXoDnAq52W0UDrNpd7bCpeygYjcShN/E92sBstFSaLqcqwJJsbkfQxSr
         W3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0OrNbu5bMQl+pauFxjSKVVG7fr+LFMir3savpzE4/1o=;
        b=PQk6gugNvjefAvanVeIc/DWnYMQnOIQA3Bop2aNNbtPUloDxEeFM3skatTn+sMdDSP
         KuhRPpDJwYwzlbOAOmy/MW6IsUP1O3SiZJpoz0423LBrltwOEdpiWqOCQ0f/OaqELSZW
         8UOtG3UuhlgBlGePHBtag3otIKzxu/zXDFyqf8w+bVPWUvOhttgUIHd96W6Yd8GOOgJc
         t4MpUW97ZYt5SwmZGr6JRgtUfXS6rIOMKtgo9QTjBztKrc8vGXnFoLkA+svAibyC30gA
         xDvzf2gD2RAX/HrNAIvfTCvEcV3AcpenMkWR8WbQgQ1/sXdReIsQtUbZcrxoR431xjyb
         9LqA==
X-Gm-Message-State: AOAM530pVpdM2VxfnsYhTNG8gmrWRXWSii//2A5XAdjQKJzeMYW3HJzs
        eSd7K85DmESP3wNFdVdO019swMERnWn72C3r
X-Google-Smtp-Source: ABdhPJwJ04SnM0OoZqm8BNCyruTM/dhJBug9XIyMJRfffL5tcly7qQR9NrOmW2KjCwp5C85CoGKYzA==
X-Received: by 2002:adf:f482:: with SMTP id l2mr452454wro.26.1603906069870;
        Wed, 28 Oct 2020 10:27:49 -0700 (PDT)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id v6sm120307wmj.6.2020.10.28.10.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 10:27:49 -0700 (PDT)
Message-ID: <5339059d53b26837d1b90217ec21eb0d99e938ad.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH] override CFLAGS too
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        linux-fscrypt@vger.kernel.org
Date:   Wed, 28 Oct 2020 17:27:48 +0000
In-Reply-To: <20201028171718.GA2726300@gmail.com>
References: <20201026204831.3337360-1-luca.boccassi@gmail.com>
         <20201026221019.GB185792@sol.localdomain>
         <035c541ee436febb5c32df4af469c06189c13e20.camel@gmail.com>
         <20201028171718.GA2726300@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2020-10-28 at 10:17 -0700, Eric Biggers wrote:
> On Tue, Oct 27, 2020 at 10:30:20AM +0000, Luca Boccassi wrote:
> > On Mon, 2020-10-26 at 15:10 -0700, Eric Biggers wrote:
> > > [+Jes Sorensen]
> > > 
> > > On Mon, Oct 26, 2020 at 08:48:31PM +0000, luca.boccassi@gmail.com wrote:
> > > > From: Romain Perier <romain.perier@gmail.com>
> > > > 
> > > > Currently, CFLAGS are defined by default. It has to effect to define its
> > > > c-compiler options only when the variable is not defined on the cmdline
> > > > by the user, it is not possible to merge or mix both, while it could
> > > > be interesting for using the app warning cflags or the pkg-config
> > > > cflags, while using the distributor flags. Most distributions packages
> > > > use their own compilation flags, typically for hardening purpose but not
> > > > only. This fixes the issue by using the override keyword.
> > > > 
> > > > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > > > ---
> > > > Currently used in Debian, were we want to append context-specific
> > > > compiler flags (eg: for compiler hardening options) without
> > > > removing the default flags
> > > > 
> > > >  Makefile | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/Makefile b/Makefile
> > > > index 6c6c8c9..5020cac 100644
> > > > --- a/Makefile
> > > > +++ b/Makefile
> > > > @@ -35,14 +35,15 @@
> > > >  cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
> > > >  	      then echo $(1); fi)
> > > >  
> > > > -CFLAGS ?= -O2 -Wall -Wundef					\
> > > > +override CFLAGS := -O2 -Wall -Wundef				\
> > > >  	$(call cc-option,-Wdeclaration-after-statement)		\
> > > >  	$(call cc-option,-Wimplicit-fallthrough)		\
> > > >  	$(call cc-option,-Wmissing-field-initializers)		\
> > > >  	$(call cc-option,-Wmissing-prototypes)			\
> > > >  	$(call cc-option,-Wstrict-prototypes)			\
> > > >  	$(call cc-option,-Wunused-parameter)			\
> > > > -	$(call cc-option,-Wvla)
> > > > +	$(call cc-option,-Wvla)					\
> > > > +	$(CFLAGS)
> > > >  
> > > >  override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> > > 
> > > I had it like this originally, but Jes requested that it be changed to the
> > > current way for rpm packaging.  See the thread:
> > > https://lkml.kernel.org/linux-fscrypt/20200515205649.1670512-3-Jes.Sorensen@gmail.com/T/#u
> > > 
> > > Can we come to an agreement on one way to do it?
> > > 
> > > To me, the approach with 'override' makes more sense.  The only non-warning
> > > option is -O2, and if someone doesn't want that, they can just specify
> > > CFLAGS=-O0 and it will override -O2 (since the last option "wins").
> > > 
> > > Jes, can you explain why that way doesn't work with rpm?
> > 
> > I see - I'm pretty sure what we want to override is the optimization
> > flag (and any other flag that affect the binary, eg: debugging
> > symbols), but not the other flags that you set (eg: warnings).
> > 
> > So, how about this v2:
> > 
> > From b48d09b1868cfa50b2cd61eec2951f722943e421 Mon Sep 17 00:00:00 2001
> > From: Romain Perier <romain.perier@gmail.com>
> > Date: Sun, 19 Apr 2020 09:24:09 +0200
> > Subject: [PATCH] override CFLAGS too
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
> >  Makefile | 23 ++++++++++++++---------
> >  1 file changed, 14 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 6c6c8c9..82abfe9 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -35,14 +35,19 @@
> >  cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
> >  	      then echo $(1); fi)
> >  
> > -CFLAGS ?= -O2 -Wall -Wundef					\
> > +# Flags that callers can override
> > +CFLAGS ?= -O2
> > +
> > +# Flags that we always want to use
> > +INTERNAL_CFLAGS := -Wall -Wundef				\
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
> >  
> > @@ -65,7 +70,7 @@ PKGCONF         ?= pkg-config
> >  .build-config: FORCE
> >  	@flags=$$(							\
> >  		echo 'CC=$(CC)';					\
> > -		echo 'CFLAGS=$(CFLAGS)';				\
> > +		echo 'CFLAGS=$(INTERNAL_CFLAGS)';			\
> >  		echo 'CPPFLAGS=$(CPPFLAGS)';				\
> >  		echo 'LDFLAGS=$(LDFLAGS)';				\
> >  		echo 'LDLIBS=$(LDLIBS)';				\
> > @@ -98,7 +103,7 @@ endif
> >  #### Library
> >  
> >  SOVERSION       := 0
> > -LIB_CFLAGS      := $(CFLAGS) -fvisibility=hidden
> > +LIB_CFLAGS      := $(INTERNAL_CFLAGS) -fvisibility=hidden
> >  LIB_SRC         := $(wildcard lib/*.c)
> >  LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
> >  STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
> > @@ -121,7 +126,7 @@ DEFAULT_TARGETS += libfsverity.a
> >  # Create shared library
> >  libfsverity.so.$(SOVERSION):$(SHARED_LIB_OBJ)
> >  	$(QUIET_CCLD) $(CC) -o $@ -Wl,-soname=$@ -shared $+ \
> > -		$(CFLAGS) $(LDFLAGS) $(LDLIBS)
> > +		$(INTERNAL_CFLAGS) $(LDFLAGS) $(LDLIBS)
> >  
> >  DEFAULT_TARGETS += libfsverity.so.$(SOVERSION)
> >  
> > @@ -160,23 +165,23 @@ TEST_PROGRAMS     := $(TEST_PROG_SRC:programs/%.c=%)
> >  
> >  # Compile program object files
> >  $(ALL_PROG_OBJ): %.o: %.c $(ALL_PROG_HEADERS) .build-config
> > -	$(QUIET_CC) $(CC) -o $@ -c $(CPPFLAGS) $(CFLAGS) $<
> > +	$(QUIET_CC) $(CC) -o $@ -c $(CPPFLAGS) $(INTERNAL_CFLAGS) $<
> >  
> >  # Link the fsverity program
> >  ifdef USE_SHARED_LIB
> >  fsverity: $(FSVERITY_PROG_OBJ) libfsverity.so
> >  	$(QUIET_CCLD) $(CC) -o $@ $(FSVERITY_PROG_OBJ) \
> > -		$(CFLAGS) $(LDFLAGS) -L. -lfsverity
> > +		$(INTERNAL_CFLAGS) $(LDFLAGS) -L. -lfsverity
> >  else
> >  fsverity: $(FSVERITY_PROG_OBJ) libfsverity.a
> > -	$(QUIET_CCLD) $(CC) -o $@ $+ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
> > +	$(QUIET_CCLD) $(CC) -o $@ $+ $(INTERNAL_CFLAGS) $(LDFLAGS) $(LDLIBS)
> >  endif
> >  
> >  DEFAULT_TARGETS += fsverity
> >  
> >  # Link the test programs
> >  $(TEST_PROGRAMS): %: programs/%.o $(PROG_COMMON_OBJ) libfsverity.a
> > -	$(QUIET_CCLD) $(CC) -o $@ $+ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
> > +	$(QUIET_CCLD) $(CC) -o $@ $+ $(INTERNAL_CFLAGS) $(LDFLAGS) $(LDLIBS)
> >  
> >  ##############################################################################
> 
> I think the following accomplishes the same thing much more easily:
> 
> diff --git a/Makefile b/Makefile
> index 6c6c8c9..cff8d36 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -35,14 +35,17 @@
>  cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
>  	      then echo $(1); fi)
>  
> -CFLAGS ?= -O2 -Wall -Wundef					\
> +CFLAGS ?= -O2
> +
> +override CFLAGS := -Wall -Wundef				\
>  	$(call cc-option,-Wdeclaration-after-statement)		\
>  	$(call cc-option,-Wimplicit-fallthrough)		\
>  	$(call cc-option,-Wmissing-field-initializers)		\
>  	$(call cc-option,-Wmissing-prototypes)			\
>  	$(call cc-option,-Wstrict-prototypes)			\
>  	$(call cc-option,-Wunused-parameter)			\
> -	$(call cc-option,-Wvla)
> +	$(call cc-option,-Wvla)					\
> +	$(CFLAGS)

It does indeed, that works for me, thanks.

-- 
Kind regards,
Luca Boccassi

