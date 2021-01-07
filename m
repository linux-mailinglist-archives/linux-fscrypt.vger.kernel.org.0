Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC39D2ECAD2
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 08:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbhAGHMv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 02:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbhAGHMu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 02:12:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4C8230FC;
        Thu,  7 Jan 2021 07:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610003529;
        bh=tit6+iYfhOPvBLWpW1yajKmN6zgvtE2sN3jMGdZQ7Fk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DL2cU4YRLCojCqJo4Liy7B60cPapsBb3wY1eYvZlueUdgWqQrPvq83MiqxQWD5s5T
         35eneD2tIuiJoRBvmD6JxrSSA4+nKOVDBbhJQZWYM2WnoAkenEx4ajJN2zW8DePY0e
         EnDrsb66OTSRlkVwbOKG8sRDOQNXnf40P6Z153cXY7qiHfnTJb7b3F43CmbWBnhNrq
         qgnn8ObKb1o9LNiKVdwJG3HmWUgaj6eNa6wMXP+JmMK0Xqc211NpGPR0NNyR/bZYGx
         JhlhwIRMeAlRP+Zb2oODJ0/ULifYp3iYXnHdiSFhfmeJJ3tofKFpdRAgze5YFraHVi
         WNzJGV6HUlA4g==
Date:   Wed, 6 Jan 2021 23:12:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH 0/5] Add KDF implementations to crypto API
Message-ID: <X/a0R7ttkuO2Bi5p@sol.localdomain>
References: <4616980.31r3eYUQgx@positron.chronox.de>
 <X/OUt7+wGGEPkWh8@sol.localdomain>
 <3f8cda66411d4e82074808657df7f1bbbcff37a9.camel@chronox.de>
 <X/axTBTMGpJ07tft@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X/axTBTMGpJ07tft@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jan 06, 2021 at 10:59:24PM -0800, Eric Biggers wrote:
> On Thu, Jan 07, 2021 at 07:37:05AM +0100, Stephan Mueller wrote:
> > Am Montag, dem 04.01.2021 um 14:20 -0800 schrieb Eric Biggers:
> > > On Mon, Jan 04, 2021 at 10:45:57PM +0100, Stephan Müller wrote:
> > > > The HKDF addition is used to replace the implementation in the filesystem
> > > > crypto extension. This code was tested by using an EXT4 encrypted file
> > > > system that was created and contains files written to by the current
> > > > implementation. Using the new implementation a successful read of the
> > > > existing files was possible and new files / directories were created
> > > > and read successfully. These newly added file system objects could be
> > > > successfully read using the current code. Yet if there is a test suite
> > > > to validate whether the invokcation of the HKDF calculates the same
> > > > result as the existing implementation, I would be happy to validate
> > > > the implementation accordingly.
> > > 
> > > See https://www.kernel.org/doc/html/latest/filesystems/fscrypt.html#tests
> > > for how to run the fscrypt tests.  'kvm-xfstests -c ext4 generic/582' should
> > > be
> > > enough for this, though you could run all the tests if you want.
> > 
> > I ran the $(kvm-xfstests -c encrypt -g auto) on 5.11-rc2 with and without my
> > HKDF changes. I.e. the testing shows the same results for both kernels which
> > seems to imply that my HKDF changes do not change the behavior.
> > 
> > I get the following errors in both occasions - let me know if I should dig a
> > bit more.
> 
> The command you ran runs almost all xfstests with the test_dummy_encryption
> mount option enabled, which is different from running the encryption tests --
> and in fact it skips the real encryption tests, so it doesn't test the
> correctness of HKDF at all.  It looks like you saw some unrelated test failures.
> Sorry if I wasn't clear -- by "all tests" I meant all encryption tests, i.e.
> 'kvm-xfstests -c ext4 -g encrypt'.  Also, even the single test generic/582
> should be sufficient to test HKDF, as I mentioned.
> 

I just did it myself and the tests pass.

- Eric
