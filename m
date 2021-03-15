Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BD933C9B7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Mar 2021 00:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhCOXJz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Mar 2021 19:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232143AbhCOXJn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Mar 2021 19:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36AA764F01;
        Mon, 15 Mar 2021 23:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615849783;
        bh=Y9UPZRfSSlUbaTp3Ol65+LmHNaa9fwVLQKZyb+bcP94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o9CHKT63L6TiEmHFeJ7s+gFP/Xql3SXmVpkMa0D0h2e6LUJ7Kswfi1UnYsZDYJSxi
         GwjtJ6iTzUP/H8sLMUayMXK+TB8N+8G5v8dmxTPgQZTjAiH9tvL5AEi1aFqyzBCIRj
         KtAVaZhX8gWEg1rp2z063A9mvKWvP/kKHl16xvI1WEFoxT0MMqxvGXP9iKnuNzJuNL
         Uj19WC1iVkCE9SzoQPNVq4B79U7SefzlG9g0LLgQWKlIrjgscSJMqCKP22bQnewOL1
         TIO0haP0CwkMrnqLLku5Y0AX+vD/+dw3LjlMx85ZQcGC+yH2S+wh4VJpZR0NTuBVdI
         IXAJt3PNleXzQ==
Date:   Mon, 15 Mar 2021 16:09:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs: support fsverity
Message-ID: <YE/pNfSCNdJkXtWN@gmail.com>
References: <cover.1614971203.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1614971203.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Mar 05, 2021 at 11:26:28AM -0800, Boris Burkov wrote:
> This patchset provides support for fsverity in btrfs.
> 
> At a high level, we store the verity descriptor and Merkle tree data
> in the file system btree with the file's inode as the objectid, and
> direct reads/writes to those items to implement the generic fsverity
> interface required by fs/verity/.
> 
> The first patch is a preparatory patch which adds a notion of
> compat_flags to the btrfs_inode and inode_item in order to allow
> enabling verity on a file without making the file system unmountable for
> older kernels. (It runs afoul of the leaf corruption check otherwise)
> 
> The second patch is the bulk of the fsverity implementation. It
> implements the fsverity interface and adds verity checks for the typical
> file reading case.
> 
> The third patch cleans up the corner cases in readpage, covering inline
> extents, preallocated extents, and holes.
> 
> The fourth patch handles direct io of a veritied file by falling back to
> buffered io.
> 
> The fifth patch handles crashes mid-verity enable via orphan items
> 

Can you include information about how this was tested?

Also, fsverity-utils works with btrfs as-is, correct?

- Eric
