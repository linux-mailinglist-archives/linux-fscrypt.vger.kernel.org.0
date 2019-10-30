Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE1EEA2AC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Oct 2019 18:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfJ3RiB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Oct 2019 13:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbfJ3RiB (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Oct 2019 13:38:01 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E080B205ED;
        Wed, 30 Oct 2019 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572457080;
        bh=I+taz+0JlPyC4PxpulZqCmxrYW7pkekzmqmeVUw2D8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=soBGqRNpMSdSVNQfrQvw1BsNqq/ZVZqMgDb9RyP+UfXew7X31ml4kNM0WigxgUm08
         tmbXvh/5RRRmf9DiKZe+D1DGwsgDELs5Tduu269t75uApg6vLRalkep2QcK7+YqQOY
         P0eQpNClJ+pXWPX9E7Dpg4PaF+FCG0Ds2/0DEpXc=
Date:   Wed, 30 Oct 2019 10:37:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Gwendal Grignou <gwendal@chromium.org>, Chao Yu <chao@kernel.org>,
        Ryo Hashimoto <hashimoto@chromium.org>, sukhomlinov@google.com,
        groeck@chromium.org, apronin@chromium.org,
        linux-doc@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Revert "ext4 crypto: fix to check feature status before
 get policy"
Message-ID: <20191030173758.GC693@sol.localdomain>
Mail-Followup-To: Douglas Anderson <dianders@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>, Chao Yu <chao@kernel.org>,
        Ryo Hashimoto <hashimoto@chromium.org>, sukhomlinov@google.com,
        groeck@chromium.org, apronin@chromium.org,
        linux-doc@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
References: <20191030100618.1.Ibf7a996e4a58e84f11eec910938cfc3f9159c5de@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030100618.1.Ibf7a996e4a58e84f11eec910938cfc3f9159c5de@changeid>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Douglas,

On Wed, Oct 30, 2019 at 10:06:25AM -0700, Douglas Anderson wrote:
> This reverts commit 0642ea2409f3 ("ext4 crypto: fix to check feature
> status before get policy").
> 
> The commit made a clear and documented ABI change that is not backward
> compatible.  There exists userspace code [1] that relied on the old
> behavior and is now broken.
> 
> While we could entertain the idea of updating the userspace code to
> handle the ABI change, it's my understanding that in general ABI
> changes that break userspace are frowned upon (to put it nicely).
> 
> NOTE: if we for some reason do decide to entertain the idea of
> allowing the ABI change and updating userspace, I'd appreciate any
> help on how we should make the change.  Specifically the old code
> relied on the different return values to differentiate between
> "KeyState::NO_KEY" and "KeyState::NOT_SUPPORTED".  I'm no expert on
> the ext4 encryption APIs (I just ended up here tracking down the
> regression [2]) so I'd need a bit of handholding from someone.
> 
> [1] https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/master/cryptohome/dircrypto_util.cc#73
> [2] https://crbug.com/1018265
> 
> Fixes: 0642ea2409f3 ("ext4 crypto: fix to check feature status before get policy")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> 
>  Documentation/filesystems/fscrypt.rst | 3 +--
>  fs/ext4/ioctl.c                       | 2 --
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 8a0700af9596..4289c29d7c5a 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -562,8 +562,7 @@ FS_IOC_GET_ENCRYPTION_POLICY_EX can fail with the following errors:
>    or this kernel is too old to support FS_IOC_GET_ENCRYPTION_POLICY_EX
>    (try FS_IOC_GET_ENCRYPTION_POLICY instead)
>  - ``EOPNOTSUPP``: the kernel was not configured with encryption
> -  support for this filesystem, or the filesystem superblock has not
> -  had encryption enabled on it
> +  support for this filesystem
>  - ``EOVERFLOW``: the file is encrypted and uses a recognized
>    encryption policy version, but the policy struct does not fit into
>    the provided buffer
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0b7f316fd30f..13d97fb797b4 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1181,8 +1181,6 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  #endif
>  	}
>  	case EXT4_IOC_GET_ENCRYPTION_POLICY:
> -		if (!ext4_has_feature_encrypt(sb))
> -			return -EOPNOTSUPP;
>  		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
>  

Thanks for reporting this.  Can you elaborate on exactly why returning
EOPNOTSUPP breaks things in the Chrome OS code?  Since encryption is indeed not
supported, why isn't "KeyState::NOT_SUPPORTED" correct?

Note that the state after this revert will be:

- FS_IOC_GET_ENCRYPTION_POLICY on ext4 => ENODATA
- FS_IOC_GET_ENCRYPTION_POLICY on f2fs => EOPNOTSUPP
- FS_IOC_GET_ENCRYPTION_POLICY_EX on ext4 => EOPNOTSUPP
- FS_IOC_GET_ENCRYPTION_POLICY_EX on f2fs => EOPNOTSUPP

So if this code change is made, the documentation would need to be updated to
explain that the error code from FS_IOC_GET_ENCRYPTION_POLICY is
filesystem-specific (which we'd really like to avoid...), and that
FS_IOC_GET_ENCRYPTION_POLICY_EX handles this case differently.  Or else the
other three would need to be changed to ENODATA -- which for
FS_IOC_GET_ENCRYPTION_POLICY on f2fs would be an ABI break in its own right,
though it's possible that no one would notice.

Is your proposal to keep the error filesystem-specific for now?

BTW, the crbug.com link is not publicly viewable, so should not be included in
the commit message.

- Eric
