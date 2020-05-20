Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F0C1DC262
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 00:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgETWzR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 18:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgETWzR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 18:55:17 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E09020708;
        Wed, 20 May 2020 22:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590015317;
        bh=E1DfljRpbA6H0IZzsWRX/4aXJ88Hj2y4PqJ5SvnK5Ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/TPnlDOY0Ch8TASNkZrTmEyp4fQfD43DMOlLeLHPLMxpUSL9g5UzvNMe75nkUORJ
         c0KlLIY/Qom29xZQp7fFPrnSEuJVAD4ZXPOiZNM9gcZpiZdfUrsnsQ10NdRWNp4VFS
         T+T6tgycX/Vzju3MKAcDuUz2T064ekJezx3O0KMg=
Date:   Wed, 20 May 2020 15:55:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH 0/4] fscrypt: make '-o test_dummy_encryption' support v2
 policies
Message-ID: <20200520225515.GC19246@sol.localdomain>
References: <20200512233251.118314-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512233251.118314-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 12, 2020 at 04:32:47PM -0700, Eric Biggers wrote:
> v1 encryption policies are deprecated in favor of v2, and some new
> features (e.g. encryption+casefolding) are only being added for v2.
> 
> As a result, the "test_dummy_encryption" mount option (which is used for
> encryption I/O testing with xfstests) needs to support v2 policies.
> 
> Therefore, this patchset adds support for specifying
> "test_dummy_encryption=v2" (or "test_dummy_encryption=v1").
> To make this possible, it reworks the way the test_dummy_encryption
> mount option is handled to make it more flexible than a flag, and to
> automatically add the test dummy key to the filesystem's keyring.
> 
> Patch 4 additionally changes the default to "v2".
> 
> This patchset applies to v5.7-rc4.
> 
> Eric Biggers (4):
>   linux/parser.h: add include guards
>   fscrypt: add fscrypt_add_test_dummy_key()
>   fscrypt: support test_dummy_encryption=v2
>   fscrypt: make test_dummy_encryption use v2 by default
> 

All applied to fscrypt.git#master for 5.8
(including the sysfs additions to patch 3, as was discussed)

- Eric
