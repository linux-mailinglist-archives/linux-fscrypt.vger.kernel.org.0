Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE21433C9AF
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Mar 2021 00:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhCOXHq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Mar 2021 19:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhCOXH0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Mar 2021 19:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 224A964F01;
        Mon, 15 Mar 2021 23:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615849646;
        bh=216nMEowzSSSHh5Fh7E+RUDl9qhqxuC/Rz+ZbSY9WYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KaaGFfEykq3eS1IbHdscDAGxAysgM/veoE4wDshY7kSpz8XKNPGciXKTC081PQ/U6
         73cPY07Mst0hw1Irq6qFvv2b3MaU81vIY0D/jSwjr6sbY15Yzf/bhzKcIGHz5KgyaR
         ICawpolfbfMSqsiBGbUddtKrlHG7BwLAf+o3X+hNxBlEyS7Lzrf6SVrgSLOdh/R4Ty
         cqMFe8Dw+luLnEIbtr7aoOTtdjdgrFHwkwv0wGmjcjrgMjLq8de7JbKjI/U8hr7MtI
         PYhoT08eGnuBbBLRpJNPANLJUVHPDAGGv9lZaOE4xArcioNq56GV4q69r28aTmJ8Hx
         mFceRlPKksF/A==
Date:   Mon, 15 Mar 2021 16:07:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 1/5] btrfs: add compat_flags to btrfs_inode_item
Message-ID: <YE/orPeVtRAON9II@gmail.com>
References: <cover.1614971203.git.boris@bur.io>
 <f47aa729e2c15b9e3f913c4347bf24562a631772.1614971203.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f47aa729e2c15b9e3f913c4347bf24562a631772.1614971203.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Mar 05, 2021 at 11:26:29AM -0800, Boris Burkov wrote:
> The tree checker currently rejects unrecognized flags when it reads
> btrfs_inode_item. Practically, this means that adding a new flag makes
> the change backwards incompatible if the flag is ever set on a file.
> 
> Take up one of the 4 reserved u64 fields in the btrfs_inode_item as a
> new "compat_flags". These flags are zero on inode creation in btrfs and
> mkfs and are ignored by an older kernel, so it should be safe to use
> them in this way.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

How does this interact with the RO_COMPAT filesystem flag which is also being
added?

- Eric
