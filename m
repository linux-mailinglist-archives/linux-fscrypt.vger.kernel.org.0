Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90984588A1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jun 2019 19:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfF0RhV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jun 2019 13:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbfF0RhV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jun 2019 13:37:21 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B05412086D;
        Thu, 27 Jun 2019 17:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561657040;
        bh=HRfAeKXx2T34QqlBfXWllYbJahVVq1K2DsIUUpMlbTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z6rLqHS20ZnJRoOzfbvV4/zI4lkUPtUHuf4a2jckDdUIi60v2di1NSqbboU+34lMP
         yKCGBauqyB77hxCyl39z63FYeU7V7U46n1jJlr8jR2f4iOywf89cPeYkWYfaf9K1lp
         fcHt2o8EG1MgarUdvnLrRrVX6JWEv48lX3Q74rdw=
Date:   Thu, 27 Jun 2019 10:37:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     fstests@vger.kernel.org
Subject: Re: [PATCH] fscrypt: document testing with xfstests
Message-ID: <20190627173719.GH686@sol.localdomain>
References: <20190620181658.225792-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620181658.225792-1-ebiggers@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 20, 2019 at 11:16:58AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Document how to test ext4, f2fs, and ubifs encryption with xfstests.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/filesystems/fscrypt.rst | 39 +++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 87d4e266ffc86d..82efa41b0e6c02 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -649,3 +649,42 @@ Note that the precise way that filenames are presented to userspace
>  without the key is subject to change in the future.  It is only meant
>  as a way to temporarily present valid filenames so that commands like
>  ``rm -r`` work as expected on encrypted directories.
> +
> +Tests
> +=====
> +
> +To test fscrypt, use xfstests, which is Linux's de facto standard
> +filesystem test suite.  First, run all the tests in the "encrypt"
> +group on the relevant filesystem(s).  For example, to test ext4 and
> +f2fs encryption using `kvm-xfstests
> +<https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md>`_::
> +
> +    kvm-xfstests -c ext4,f2fs -g encrypt
> +
> +UBIFS encryption can also be tested this way, but it should be done in
> +a separate command, and it takes some time for kvm-xfstests to set up
> +emulated UBI volumes::
> +
> +    kvm-xfstests -c ubifs -g encrypt
> +
> +No tests should fail.  However, tests that use non-default encryption
> +modes (e.g. generic/549 and generic/550) will be skipped if the needed
> +algorithms were not built into the kernel's crypto API.  Also, tests
> +that access the raw block device (e.g. generic/399, generic/548,
> +generic/549, generic/550) will be skipped on UBIFS.
> +
> +Besides running the "encrypt" group tests, for ext4 and f2fs it's also
> +possible to run most xfstests with the "test_dummy_encryption" mount
> +option.  This option causes all new files to be automatically
> +encrypted with a dummy key, without having to make any API calls.
> +This tests the encrypted I/O paths more thoroughly.  To do this with
> +kvm-xfstests, use the "encrypt" filesystem configuration::
> +
> +    kvm-xfstests -c ext4/encrypt,f2fs/encrypt -g auto
> +
> +Because this runs many more tests than "-g encrypt" does, it takes
> +much longer to run; so also consider using `gce-xfstests
> +<https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md>`_
> +instead of kvm-xfstests::
> +
> +    gce-xfstests -c ext4/encrypt,f2fs/encrypt -g auto
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

Applied to fscrypt.git for v5.3.

- Eric
