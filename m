Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06A10477F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Nov 2019 01:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfKUAZc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 Nov 2019 19:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfKUAZb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 Nov 2019 19:25:31 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0AB20715;
        Thu, 21 Nov 2019 00:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574295931;
        bh=yeVj7Y3S4jwLOqWAEpoS0jH0Zi8pZjhp25DR2yAvo2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vUtts7yR5GM94jMHRxIU9dnnw+bG/AIyMLSWkbVE+iMVIXlty4LOnktiZg72kmA9Y
         bLEhTUX/5WsVJj84M8TcEKtTIt0gYBpSlnPo1ACZA+XOqR+1kCDOyA24IaB+y7B6yL
         LJbx2UqIhp2VEYJ4N0EPW26Xc/l82ECeMtz87Anw=
Date:   Wed, 20 Nov 2019 16:25:29 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [RFC PATCH 3/3] generic: test adding filesystem-level fscrypt
 key via key_id
Message-ID: <20191121002528.GE168530@gmail.com>
References: <20191119223130.228341-1-ebiggers@kernel.org>
 <20191119223130.228341-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119223130.228341-4-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 19, 2019 at 02:31:30PM -0800, Eric Biggers wrote:
> +# Require support for adding a key to a filesystem's fscrypt keyring via an
> +# "fscrypt-provisioning" keyring key.
> +_require_add_enckey_by_key_id()
> +{
> +	local mnt=$1
> +
> +	# Userspace support
> +	_require_xfs_io_command "add_enckey" "-k"
> +
> +	# Kernel support
> +	if $XFS_IO_PROG -c "$add_enckey -k 12345 $mnt" \
> +		|& grep -q 'Invalid argument'; then
> +		_notrun "Kernel doesn't support key_id parameter to FS_IOC_ADD_ENCRYPTION_KEY"
> +	fi
> +}

There's a bug here that makes the test not be skipped when it should.
It should say:

	if $XFS_IO_PROG -c "add_enckey -k 12345" "$mnt" \

I'll fix this in the next version.

- Eric
