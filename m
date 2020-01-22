Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13DD145EDE
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Jan 2020 23:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVW7U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Jan 2020 17:59:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgAVW7U (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Jan 2020 17:59:20 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D5E221835;
        Wed, 22 Jan 2020 22:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579733959;
        bh=PEgc7glKU+eTUcoJvJSY2cFK4bxB8lTHfVQY/rxd9nQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1/1qVGJ7dgvX7BRXVza1/cj12O3YybXAukgv+DgcaApLwrlHilg0Po8C+0NaZuKjh
         R1bg0kmBt9xA2/0vvYiPXtzqPC8DeYarFzR6h5qgSEH9/4aWbqvufBlWv9/+ty1LwW
         7pz4DFyw1ZzxD4MZh5XqQMX62UN3Nhccj2yWOsuE=
Date:   Wed, 22 Jan 2020 14:59:18 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: don't print name of busy file when removing key
Message-ID: <20200122225917.GA182745@gmail.com>
References: <20200120060732.390362-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120060732.390362-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 19, 2020 at 10:07:32PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When an encryption key can't be fully removed due to file(s) protected
> by it still being in-use, we shouldn't really print the path to one of
> these files to the kernel log, since parts of this path are likely to be
> encrypted on-disk, and (depending on how the system is set up) the
> confidentiality of this path might be lost by printing it to the log.
> 
> This is a trade-off: a single file path often doesn't matter at all,
> especially if it's a directory; the kernel log might still be protected
> in some way; and I had originally hoped that any "inode(s) still busy"
> bugs (which are security weaknesses in their own right) would be quickly
> fixed and that to do so it would be super helpful to always know the
> file path and not have to run 'find dir -inum $inum' after the fact.
> 
> But in practice, these bugs can be hard to fix (e.g. due to asynchronous
> process killing that is difficult to eliminate, for performance
> reasons), and also not tied to specific files, so knowing a file path
> doesn't necessarily help.
> 
> So to be safe, for now let's just show the inode number, not the path.
> If someone really wants to know a path they can use 'find -inum'.
> 
> Fixes: b1c0ec3599f4 ("fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt.git#master for 5.6.

- Eric
