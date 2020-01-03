Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6333312FB20
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Jan 2020 18:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgACRJa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Jan 2020 12:09:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgACRJa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Jan 2020 12:09:30 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E446C20866;
        Fri,  3 Jan 2020 17:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578071370;
        bh=/w7qV6vGafRI8Bm52uoZr3tM+ATD+r4xbclSLdlWkgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wUIyx+9baPXtBb2sY3SwZEdn58USbFg1gyCThz9D5raQaIyY6CnecVjdvQJshNUV9
         FqTp9DNdx1eAfzeICb1kWbPFCT6UE2rhQdpKe6AAnc0tUS+K3QsYKvEWCamI6hBLAD
         EQyQEt/flNKl2Y1oaaPdQqHgPxiqumWtDqy6Q5GQ=
Date:   Fri, 3 Jan 2020 09:09:28 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org
Cc:     linux-fscrypt@vger.kernel.org,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] ubifs: use IS_ENCRYPTED() instead of
 ubifs_crypt_is_encrypted()
Message-ID: <20200103170927.GO19521@gmail.com>
References: <20191209212721.244396-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209212721.244396-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 09, 2019 at 01:27:21PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> There's no need for the ubifs_crypt_is_encrypted() function anymore.
> Just use IS_ENCRYPTED() instead, like ext4 and f2fs do.  IS_ENCRYPTED()
> checks the VFS-level flag instead of the UBIFS-specific flag, but it
> shouldn't change any behavior since the flags are kept in sync.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/ubifs/dir.c     | 8 ++++----
>  fs/ubifs/file.c    | 4 ++--
>  fs/ubifs/journal.c | 6 +++---
>  fs/ubifs/ubifs.h   | 7 -------
>  4 files changed, 9 insertions(+), 16 deletions(-)

Richard, can you consider applying this to the UBIFS tree for 5.6?

- Eric
