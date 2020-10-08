Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48AF287A8E
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Oct 2020 19:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731552AbgJHRFy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Oct 2020 13:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbgJHRFy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Oct 2020 13:05:54 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F42921D7D;
        Thu,  8 Oct 2020 17:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602176753;
        bh=BcdaZq8ar4XX+2VOyCYshYDAMVSvt+n6/c1IW4iUOfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uAUcdYaozNytHFrBAl5SWYRuaP3ehrQ6a0xozh1La36HyBZjhclNRckdMr6HiV089
         pGp2BspU/uQTRZp4q1hL2s5YLQOgAezBVIQF2thcthMr8rmSUjU2COAtDCFt5NyjCQ
         KISB4BRgdtIWZEEo2y/XhRJBaQVViqg8cW79ABr0=
Date:   Thu, 8 Oct 2020 10:05:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/3] fscrypt: Add metadata encryption support
Message-ID: <20201008170551.GB1869638@gmail.com>
References: <20201005073606.1949772-1-satyat@google.com>
 <20201005073606.1949772-3-satyat@google.com>
 <20201007205221.GA1530638@gmail.com>
 <20201007232806.GB2544297@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007232806.GB2544297@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 07, 2020 at 11:28:06PM +0000, Satya Tangirala wrote:
> > This needs Kconfig help text to describe what this feature is and why anyone
> > would want to enable it.  It also needs an update to
> > Documentation/filesystems/fscrypt.rst, and a test in xfstests that tests that
> > the encryption is being done correctly.
> > 
> Sure. I forgot to mention, fwiw I did hack xfstests to enable metadata
> encryption on each device to try to test the code, and also some other
> informal tests, but as you point out, I should send out actual xfstests
> to test this.

To be clear, I'm asking for tests which verify the actual ciphertext written to
disk.  So similar to _verify_ciphertext_for_encryption_policy() in xfstests, or
to vts_kernel_encryption_test in Android's VTS.

> > Perhaps fscrypt_set_bio_crypt_ctx() should call this?  It seems there should be
> > a single function that filesystems can call that handles setting the
> > bio_crypt_ctx for both file contents and metadata encryption.
> > 
> I mistakenly dismissed this idea when I was coding this up :( - I'll do
> this for the next version... I think it'll also make supporting direct I/O
> easier in future :) . Also, I might require FS_ENCRYPTION_INLINE_CRYPT
> when enabling FS_ENCRYPTION_METADATA to maybe make the code slightly
> cleaner (unless there's a reason we want to support metadata encryption
> without FS inline encryption being enabled?).

Since metadata encryption would already depend on FS_ENCRYPTION and
BLK_INLINE_ENCRYPTION, I think it would be fine to require
FS_ENCRYPTION_INLINE_CRYPT too, in order to reduce the number of combinations.

- Eric
