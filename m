Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B142E0326
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 01:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLVAB1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 19:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgLVAB1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 19:01:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B21722512;
        Tue, 22 Dec 2020 00:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608595246;
        bh=0B1fjJpUmDjwUuU1q9++1hOekdZwq3UYDF4h0BX6Zjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=if+xzEWJw5I7fTWqW5iWUDSIRrk3AgX6spAqdowSwJzhmDHbUwpynMUXptLPESIxM
         BSrcIKTa9zojb1cFEhiudLKK0N44smj/cveKXvEb5P+omyx4jUEvknNaqQJjxayUhm
         VqXVFOM/XgQSPw/ZOEIfccaQ4ydiTGZOle4giqxWyumlVmTyszVCQnf9ptxcjYM4Zf
         WDcEk5sRJ/k0ySkQ4EUkabY7+zoyj4PTi10dzJimuT0zKkrzevx7dgmJo6BBS8klu/
         XF8d/TdV9YeK41Mwotzv8RbxRdd7L0lGq67ovdMYPK0bWJQ5k4JLHRxG/V0hiSSqUp
         TN1mZmR8nZ/xg==
Date:   Mon, 21 Dec 2020 16:00:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v6 1/3] Move -D_GNU_SOURCE to CPPFLAGS
Message-ID: <X+E3LDjQOMMVUuEv@sol.localdomain>
References: <20201221221953.256059-1-bluca@debian.org>
 <20201221232428.298710-1-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221232428.298710-1-bluca@debian.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 21, 2020 at 11:24:26PM +0000, Luca Boccassi wrote:
> Ensures it is actually defined before any include is preprocessed.

It was already at the beginning of the .c file, so this isn't a very good
explanation.  A better explanation would be "Use _GNU_SOURCE consistently in
every file rather than in just one file.  This is needed for the Windows build
in order to consistently get the MinGW version of printf.".

> diff --git a/Makefile b/Makefile
> index bfe83c4..f1ba956 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -47,7 +47,7 @@ override CFLAGS := -Wall -Wundef				\
>  	$(call cc-option,-Wvla)					\
>  	$(CFLAGS)
>  
> -override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> +override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)
>  
>  ifneq ($(V),1)
>  QUIET_CC        = @echo '  CC      ' $@;

Can you add -D_GNU_SOURCE to ./scripts/run-sparse.sh too?
Otherwise I get errors when running scripts/run-tests.sh:

[Mon Dec 21 03:52:15 PM PST 2020] Run sparse
./lib/utils.c:71:13: error: undefined identifier 'vasprintf'
./lib/utils.c:78:21: error: undefined identifier 'asprintf'
