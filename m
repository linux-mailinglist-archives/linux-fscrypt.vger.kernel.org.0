Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4BA2ECABB
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 08:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbhAGHAH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 02:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbhAGHAH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 02:00:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 342B722E00;
        Thu,  7 Jan 2021 06:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610002766;
        bh=F+29O/lRMWzhcxDLYrF0XgcNB8oKJOS4ocekLsKW6sU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LAZEVOPfzfYtXokJbutIjBLAgx9Y8jxXVgn2OP4gERpMALuQtXgtVOMPQ2zX50nMx
         VEhVL846W4k0iLO+oilS7ZKN7/yoOGmat/Z27Mfxp3DscWEKrDPMOUuHMo/lMAsPdE
         y4BRxntzFwCKTCjDxhj6GLh90nw1y8Df5VNyjf1HwieX3yOULSxGcHcJ56xp745f1O
         4jPxvORSghzuGW5b0VVZH43PC2REtDskl6IM3iPyClkXqMyKWXaJexO7SAE/+E7L6U
         cSUj/wa6YxUyk8ob/hBJy6o17Jj3SEDZElzThM62uje/aTUGv+0nzuSbIuP5K0Op7y
         k3PQ8x80yD1Ag==
Date:   Wed, 6 Jan 2021 22:59:24 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH 0/5] Add KDF implementations to crypto API
Message-ID: <X/axTBTMGpJ07tft@sol.localdomain>
References: <4616980.31r3eYUQgx@positron.chronox.de>
 <X/OUt7+wGGEPkWh8@sol.localdomain>
 <3f8cda66411d4e82074808657df7f1bbbcff37a9.camel@chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f8cda66411d4e82074808657df7f1bbbcff37a9.camel@chronox.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 07, 2021 at 07:37:05AM +0100, Stephan Mueller wrote:
> Am Montag, dem 04.01.2021 um 14:20 -0800 schrieb Eric Biggers:
> > On Mon, Jan 04, 2021 at 10:45:57PM +0100, Stephan Müller wrote:
> > > The HKDF addition is used to replace the implementation in the filesystem
> > > crypto extension. This code was tested by using an EXT4 encrypted file
> > > system that was created and contains files written to by the current
> > > implementation. Using the new implementation a successful read of the
> > > existing files was possible and new files / directories were created
> > > and read successfully. These newly added file system objects could be
> > > successfully read using the current code. Yet if there is a test suite
> > > to validate whether the invokcation of the HKDF calculates the same
> > > result as the existing implementation, I would be happy to validate
> > > the implementation accordingly.
> > 
> > See https://www.kernel.org/doc/html/latest/filesystems/fscrypt.html#tests
> > for how to run the fscrypt tests.  'kvm-xfstests -c ext4 generic/582' should
> > be
> > enough for this, though you could run all the tests if you want.
> 
> I ran the $(kvm-xfstests -c encrypt -g auto) on 5.11-rc2 with and without my
> HKDF changes. I.e. the testing shows the same results for both kernels which
> seems to imply that my HKDF changes do not change the behavior.
> 
> I get the following errors in both occasions - let me know if I should dig a
> bit more.

The command you ran runs almost all xfstests with the test_dummy_encryption
mount option enabled, which is different from running the encryption tests --
and in fact it skips the real encryption tests, so it doesn't test the
correctness of HKDF at all.  It looks like you saw some unrelated test failures.
Sorry if I wasn't clear -- by "all tests" I meant all encryption tests, i.e.
'kvm-xfstests -c ext4 -g encrypt'.  Also, even the single test generic/582
should be sufficient to test HKDF, as I mentioned.

- Eric
