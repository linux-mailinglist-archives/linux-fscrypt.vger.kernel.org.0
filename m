Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC68298B95
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 12:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771948AbgJZLRC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 07:17:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38695 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771658AbgJZLRC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 07:17:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id l15so12044271wmi.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 04:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=a9gmPTAOl4neDFVxyl37J3AqsAUgGujADSssdoX1tk8=;
        b=ittgTKQ2i8Eepn9q4mEFotPFqAKRvXetlbejRHIZhECT7KW9bwYz8pJfI2S5Pk/fLS
         8YOvKeAGZ6wIdAFsCBBIN8L2RxzrMDcQkHmuU3gDRn477uhLkKMCR0U1k/33TlKTs6th
         QPuTzkzyWMA59sP6HxEDTbJIiGlgIQgbgzMGVGZfFfiGiaLIG3a9kB/iS05tL0HdPB8X
         T0uSJrB7L2PmRo3eJpWeKDmeXgCBfFS++q94n2iFnvHvqWX7bIIIYAbGS9lTEJ2lh5xl
         AO765J9q7DCewlDae6w4nSfWpaeQUMlSFSMg8Ma/efU5ueztrrrVIV/1ZpdUnkHQxFuD
         Qjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=a9gmPTAOl4neDFVxyl37J3AqsAUgGujADSssdoX1tk8=;
        b=WMbYS6fwcc6nXSZvk0gzJzuViYAyDHehMfQ6VZtfLQXQUWdJ499spnS4Nu4lNShLkO
         4+a9K1yZJZDrVvvmMK2Ovi69tGv0NhRAHUFwU6Yh+j0ug56Ji4aC1U8APTPEznTvWR+A
         R5ffgEdmrKeJqY0f8JfPo19JMedLkkCccUfUzWM9XVvBRZy0PFEj7lS2ZdV/Pon9bRNd
         rNzp62lqTyWk5lWywFgryuJ3Ed2R9yuVzOfcFw+wmsVtN/EFV48cKIUOtkFMvqHCBTvL
         DRkWp0kYxjkAzhC0OmZjFHnbYpMZb2ssPP1+TSHI6OhV6PaxrjPNomX8vYKK+iT7mjBq
         k/Ug==
X-Gm-Message-State: AOAM5301E+Dgzxg5sHaHNW57lCdkXfB+hnbbU8VTfCnsWDvwEA5czZ66
        0gnb2jb3tyL3/evqRJSdGfpegK29k9iI7EjC
X-Google-Smtp-Source: ABdhPJyeE4kag5cyz1iHuTKEUNRT2BxoJgWUENeWHXoGLBuUwsvs6wr8KCDwDRgj/M0xnU3yLz5kkA==
X-Received: by 2002:a1c:e1c2:: with SMTP id y185mr15053313wmg.81.1603711020307;
        Mon, 26 Oct 2020 04:17:00 -0700 (PDT)
Received: from bluca-lenovo ([2a01:4b00:f419:6f00:7a8e:ed70:5c52:ea3])
        by smtp.gmail.com with ESMTPSA id m14sm22861563wro.43.2020.10.26.04.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 04:16:59 -0700 (PDT)
Message-ID: <814aecab262af15db1d0925010b385474d6f2cee.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH 2/2] Generate and install libfsverity.pc
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Mon, 26 Oct 2020 11:16:58 +0000
In-Reply-To: <20201024035645.GA83494@sol.localdomain>
References: <20201022175934.2999543-1-luca.boccassi@gmail.com>
         <20201022175934.2999543-2-luca.boccassi@gmail.com>
         <20201024035645.GA83494@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2020-10-23 at 20:56 -0700, Eric Biggers wrote:
> On Thu, Oct 22, 2020 at 06:59:34PM +0100, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@microsoft.com>
> > 
> > pkg-config is commonly used by libraries to convey information about
> > compiler flags and dependencies.
> > As packagers, we heavily rely on it so that all our tools do the right
> > thing by default regardless of the environment.
> > 
> > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> > ---
> >  Makefile              | 13 ++++++++++++-
> >  lib/libfsverity.pc.in | 10 ++++++++++
> >  scripts/do-release.sh |  2 ++
> >  3 files changed, 24 insertions(+), 1 deletion(-)
> >  create mode 100644 lib/libfsverity.pc.in
> > 
> > diff --git a/Makefile b/Makefile
> > index 122c0a2..07b828f 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -119,6 +119,15 @@ libfsverity.so:libfsverity.so.$(SOVERSION)
> >  
> >  DEFAULT_TARGETS += libfsverity.so
> >  
> > +# Create the pkg-config file
> > +libfsverity.pc:
> 
> The dependency on lib/libfsverity.pc.in should be listed here.
> 
> Also, this depends on $(PREFIX), $(LIBDIR), and $(INCDIR).  Can you also add
> those and $(BINDIR) to the string that gets written to .build-config, then add a
> dependency on .build-config?
> 
> > +	sed -e "s|@PREFIX@|$(PREFIX)|" \
> > +		-e "s|@LIBDIR@|$(LIBDIR)|" \
> > +		-e "s|@INCDIR@|$(INCDIR)|" \
> > +		lib/libfsverity.pc.in > $@
> > +
> 
> This looks messy in the build output:
> 
> 	$ make
> 	  CC       lib/compute_digest.o
> 	  CC       lib/hash_algs.o
> 	  CC       lib/sign_digest.o
> 	  CC       lib/utils.o
> 	  AR       libfsverity.a
> 	  CC       lib/compute_digest.shlib.o
> 	  CC       lib/hash_algs.shlib.o
> 	  CC       lib/sign_digest.shlib.o
> 	  CC       lib/utils.shlib.o
> 	  CCLD     libfsverity.so.0
> 	  LN       libfsverity.so
> 	sed -e "s|@PREFIX@|/usr/local|" \
> 		-e "s|@LIBDIR@|/usr/local/lib|" \
> 		-e "s|@INCDIR@|/usr/local/include|" \
> 		lib/libfsverity.pc.in > libfsverity.pc
> 	  CC       programs/utils.o
> 	  CC       programs/cmd_enable.o
> 	  CC       programs/cmd_measure.o
> 	  CC       programs/cmd_sign.o
> 	  CC       programs/fsverity.o
> 	  CCLD     fsverity
> 
> Below QUIET_LN, can you add:
> 
> 	QUIET_GEN       = @echo '  GEN     ' $@;
> 
> Then prefix the sed command with $(QUIET_GEN) so the output looks nice.
> 
> Also, $< can be used instead of lib/libfsverity.pc.in, once the dependency is
> added.
> 
> > +DEFAULT_TARGETS += libfsverity.pc
> > +
> >  ##############################################################################
> >  
> >  #### Programs
> > @@ -190,11 +199,12 @@ check:fsverity test_programs
> >  	@echo "All tests passed!"
> >  
> >  install:all
> > -	install -d $(DESTDIR)$(LIBDIR) $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
> > +	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
> >  	install -m755 fsverity $(DESTDIR)$(BINDIR)
> >  	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
> >  	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
> >  	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
> > +	install -m644 libfsverity.pc $(DESTDIR)$(LIBDIR)/pkgconfig
> >  	install -m644 include/libfsverity.h $(DESTDIR)$(INCDIR)
> >  
> >  uninstall:
> > @@ -202,6 +212,7 @@ uninstall:
> >  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
> >  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
> >  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
> > +	rm -f $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
> >  	rm -f $(DESTDIR)$(INCDIR)/libfsverity.h
> 
> 'make clean' should remove libfsverity.pc as well.
> 
> Also, libfsverity.pc should be listed in .gitignore.
> 
> - Eric

All done in v2. 'make clean' already removes the .pc file, as it's part
of the DEFAULT_TARGETS list.

-- 
Kind regards,
Luca Boccassi

