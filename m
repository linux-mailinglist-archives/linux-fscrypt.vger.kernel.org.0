Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A2E298B93
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 12:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771122AbgJZLQR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 07:16:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34062 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769597AbgJZLQO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 07:16:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so11960921wro.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 04:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=50ZcIfY+FlK6jAvvEwPYA6l/7OChLlU6T9oLyAlIt4I=;
        b=pQOdTdl0izyINkfGhN1TvVhe7BGEChfGC4z9w4GugKvotGvQsLnA4QhvjPAFLVzOMF
         IuMVMYZjM4hJBA90aNQCAsN3f4ASRSeK0FZ0p7gc5WL9EiHhmctvFs41Qcw66PKpzus5
         S53SPTQSwEWfuOirJ39QsYpYQ2NLngSABFzhDDKG8uEMNQHo04uDf7Y0tf1RFRXDWFmy
         xaUn3rtH8EBRH+ww6SzICdeF/lQ7E8YakuoiEiPjKdtI9NamTrIFSiM+UFMjt15KFkew
         U5MEi002TTXU+Qfc/M7Tky/1bnTykQE7A63hvhSH1dJSxTT3C8UIEQSz4MgjlTws/uzz
         CPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=50ZcIfY+FlK6jAvvEwPYA6l/7OChLlU6T9oLyAlIt4I=;
        b=ipkog+j3r/P5UraLQhbSCEJojN8zPdV4unYA0IX0yZkirs7A3fxy56SzFGQTmZpfEC
         SnK/FCQzxM+5tRP3ooqhUitvOnD0ARqZpfl0G4yHTAYi6rrQPMJHMjUH8TiiM4dWmRgu
         YUA8hXCpT9jjB46Z0+BPBvc59cDwAkh821oiHA5YNLZaaCewMti07U1piQ3TOB6pDJiZ
         4ooPuZTNJsbAuYCs1yGvQ+XJZeLHVJP/4ae3SPQ0oPZUZJ9+B4R2dZLwBgRvbLeGK1DO
         XMysvlgY8CubggdzGeplNb21cMIbPBvt6fZ+gHkLL/5jOz3SlgubJjrbu2O0MY7EIdBj
         bM5g==
X-Gm-Message-State: AOAM533TMDNVScVeZR77XjdQicRCOuMQ2mrXuXjldfGfCef3zXwA6VoH
        9P5OJWdMg87z16E1d+l84qQ=
X-Google-Smtp-Source: ABdhPJz68vDMlfSFkqanINs1fbgMlcyhMJ5BAk4Nvw8y4lrYx+Fj0GpifUWLKA0hPe3h2gG3FwDuyQ==
X-Received: by 2002:a5d:5090:: with SMTP id a16mr16406778wrt.281.1603710972822;
        Mon, 26 Oct 2020 04:16:12 -0700 (PDT)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id o186sm20803154wmb.12.2020.10.26.04.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 04:16:12 -0700 (PDT)
Message-ID: <85732884d7a7c256a179701b4b1141552026b0bd.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH 1/2] Use pkg-config to get libcrypto
 build flags
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Mon, 26 Oct 2020 11:16:11 +0000
In-Reply-To: <20201024040726.GB83494@sol.localdomain>
References: <20201022175934.2999543-1-luca.boccassi@gmail.com>
         <20201024040726.GB83494@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2020-10-23 at 21:07 -0700, Eric Biggers wrote:
> On Thu, Oct 22, 2020 at 06:59:33PM +0100, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@microsoft.com>
> > 
> > Especially when cross-compiling or other such cases, it might be necessary
> > to pass additional compiler flags. This is commonly done via pkg-config,
> > so use it if available, and fall back to the hardcoded -lcrypto if not.
> > 
> > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> > ---
> >  Makefile | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 3fc1bec..122c0a2 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -58,6 +58,7 @@ BINDIR          ?= $(PREFIX)/bin
> >  INCDIR          ?= $(PREFIX)/include
> >  LIBDIR          ?= $(PREFIX)/lib
> >  DESTDIR         ?=
> > +PKGCONF         ?= pkg-config
> >  
> >  # Rebuild if a user-specified setting that affects the build changed.
> >  .build-config: FORCE
> > @@ -69,7 +70,8 @@ DESTDIR         ?=
> >  
> >  DEFAULT_TARGETS :=
> >  COMMON_HEADERS  := $(wildcard common/*.h)
> > -LDLIBS          := -lcrypto
> > +LDLIBS          := $(shell $(PKGCONF) libcrypto --libs 2>/dev/null || echo -lcrypto)
> > +CFLAGS          += $(shell $(PKGCONF) libcrypto --cflags 2>/dev/null || echo)
> 
> There should be a way to prevent pkg-config from being used if someone wants to
> link to a local copy of libcrypto.  One might expect setting PKGCONF to an empty
> string to work, and it kind of does, but then the shell command executes
> "libcrypto", which is strange.  How about quoting "$(PKGCONF)" so that the shell
> command is guaranteed to fail as expected in that case?
> 
> - Eric

Sure, done in v2.

-- 
Kind regards,
Luca Boccassi

