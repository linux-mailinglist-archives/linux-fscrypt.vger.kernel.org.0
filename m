Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67BCD1173EB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 19:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfLISS3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 13:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfLISS3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 13:18:29 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA2EC2080D;
        Mon,  9 Dec 2019 18:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575915509;
        bh=5Xae/bF3FMRbrd9T7PqTMB/ISEVVGLMSLvUQwEtLh78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZyAaQ+7tkf5YkdNKPoWULUcKbTOQ6MNzpod+eRF5ANgETIcAqU27SJvhN/ULyWPyW
         tv9m4ZCxiwEeLlnJ11aQg6Tnbsk8dO0q1Ji2/tEfx2J6srY/RzoaHSCq9DPl9wMeRY
         0NY63Odff5e3afGa6f25xA7Aj3Nd8RIEkVD7jnnQ=
Date:   Mon, 9 Dec 2019 10:18:27 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org, Satya Tangirala <satyat@google.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 0/5] xfstests: verify ciphertext of IV_INO_LBLK_64
 encryption policies
Message-ID: <20191209181826.GC149190@gmail.com>
References: <20191202230155.99071-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202230155.99071-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 02, 2019 at 03:01:50PM -0800, Eric Biggers wrote:
> Hello,
> 
> This series adds an xfstest which tests that the encryption for
> IV_INO_LBLK_64 encryption policies is being done correctly.
> 
> IV_INO_LBLK_64 is a new fscrypt policy flag which modifies the
> encryption to be optimized for inline encryption hardware compliant with
> the UFS v2.1 standard or the upcoming version of the eMMC standard.  For
> more information, see the kernel patchset:
> https://lore.kernel.org/linux-fscrypt/20191024215438.138489-1-ebiggers@kernel.org/T/#u
> 
> The kernel patches have been merged into mainline and will be in v5.5.
> 
> In addition to the latest kernel, to run on ext4 this test also needs a
> version of e2fsprogs built from the master branch, in order to get
> support for formatting the filesystem with '-O stable_inodes'.
> 
> As usual, the test will skip itself if the prerequisites aren't met.
> 
> No real changes since v1; just rebased onto the latest xfstests master
> branch and updated the cover letter.
> 
> Eric Biggers (5):
>   fscrypt-crypt-util: create key_and_iv_params structure
>   fscrypt-crypt-util: add HKDF context constants
>   common/encrypt: create named variables for UAPI constants
>   common/encrypt: support verifying ciphertext of IV_INO_LBLK_64
>     policies
>   generic: verify ciphertext of IV_INO_LBLK_64 encryption policies
> 
>  common/encrypt           | 126 +++++++++++++++++++++++++-------
>  src/fscrypt-crypt-util.c | 151 ++++++++++++++++++++++++++++-----------
>  tests/generic/805        |  43 +++++++++++
>  tests/generic/805.out    |   6 ++
>  tests/generic/group      |   1 +
>  5 files changed, 259 insertions(+), 68 deletions(-)
>  create mode 100644 tests/generic/805
>  create mode 100644 tests/generic/805.out
> 

Ping.  Does anyone want to take a look at this?  Satya?

- Eric
