Return-Path: <linux-fscrypt+bounces-85-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB3C6810C9C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Dec 2023 09:41:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66F6E1F21055
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Dec 2023 08:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AADF1DDDC;
	Wed, 13 Dec 2023 08:41:31 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83AA5;
	Wed, 13 Dec 2023 00:41:26 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5D36767373; Wed, 13 Dec 2023 09:41:23 +0100 (CET)
Date: Wed, 13 Dec 2023 09:41:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 1/3] btrfs: call btrfs_close_devices from ->kill_sb
Message-ID: <20231213084123.GA6184@lst.de>
References: <20231213040018.73803-1-ebiggers@kernel.org> <20231213040018.73803-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213040018.73803-2-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 12, 2023 at 08:00:16PM -0800, Eric Biggers wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> blkdev_put must not be called under sb->s_umount to avoid a lock order
> reversal with disk->open_mutex once call backs from block devices to
> the file system using the holder ops are supported.  Move the call
> to btrfs_close_devices into btrfs_free_fs_info so that it is closed
> from ->kill_sb (which is also called from the mount failure handling
> path unlike ->put_super) as well as when an fs_info is freed because
> an existing superblock already exists.

Thanks, this looks roughly the same to what I have locally.

I did in fact forward port everything missing from the get_super
series yesterday, but on my test setup btrfs/142 hangs even in the
baseline setup.  I went back to Linux before giving up for now.

Josef, any chane you could throw this branch:

    git://git.infradead.org/users/hch/misc.git btrfs-holder

into your CI setup and see if it sticks?  Except for the trivial last
three patches this is basically what you reviewed already, although
there was some heavy rebasing due to the mount API converison.


