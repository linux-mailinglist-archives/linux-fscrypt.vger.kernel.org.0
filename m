Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A052B5197
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 20:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbgKPTto (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 14:49:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgKPTtn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 14:49:43 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 308162078E;
        Mon, 16 Nov 2020 19:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605556183;
        bh=9FE2KtR+IehS1RXA8qU0fhm9wTBUQaq0fSBy9snon8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JcmQKlO38CIgRsATTx3KE6RroMop3zQOVhM4rPdtnUHDBwGEgxEFnc8M9+dDMuzw8
         Pi1wnOz9rO72SElennxOg+j+8WFOsuWq0FjiC9bUS0+U9kmXYIZgeLb0/e9YpQbBZ8
         vdhEj1gSxs2KwRi9ELeHzXhKeJdSdxHVEDkvoYPc=
Date:   Mon, 16 Nov 2020 11:49:41 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-api@vger.kernel.org
Subject: Re: [PATCH] fscrypt: remove kernel-internal constants from UAPI
 header
Message-ID: <X7LX1RGLo/5NnHKE@sol.localdomain>
References: <20201024005132.495952-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201024005132.495952-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Oct 23, 2020 at 05:51:31PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> There isn't really any valid reason to use __FSCRYPT_MODE_MAX or
> FSCRYPT_POLICY_FLAGS_VALID in a userspace program.  These constants are
> only meant to be used by the kernel internally, and they are defined in
> the UAPI header next to the mode numbers and flags only so that kernel
> developers don't forget to update them when adding new modes or flags.
> 
> In https://lkml.kernel.org/r/20201005074133.1958633-2-satyat@google.com
> there was an example of someone wanting to use __FSCRYPT_MODE_MAX in a
> user program, and it was wrong because the program would have broken if
> __FSCRYPT_MODE_MAX were ever increased.  So having this definition
> available is harmful.  FSCRYPT_POLICY_FLAGS_VALID has the same problem.
> 
> So, remove these definitions from the UAPI header.  Replace
> FSCRYPT_POLICY_FLAGS_VALID with just listing the valid flags explicitly
> in the one kernel function that needs it.  Move __FSCRYPT_MODE_MAX to
> fscrypt_private.h, remove the double underscores (which were only
> present to discourage use by userspace), and add a BUILD_BUG_ON() and
> comments to (hopefully) ensure it is kept in sync.
> 
> Keep the old name FS_POLICY_FLAGS_VALID, since it's been around for
> longer and there's a greater chance that removing it would break source
> compatibility with some program.  Indeed, mtd-utils is using it in
> an #ifdef, and removing it would introduce compiler warnings (about
> FS_POLICY_FLAGS_PAD_* being redefined) into the mtd-utils build.
> However, reduce its value to 0x07 so that it only includes the flags
> with old names (the ones present before Linux 5.4), and try to make it
> clear that it's now "frozen" and no new flags should be added to it.
> 
> Fixes: 2336d0deb2d4 ("fscrypt: use FSCRYPT_ prefix for uapi constants")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt.git#master for 5.11.

- Eric
