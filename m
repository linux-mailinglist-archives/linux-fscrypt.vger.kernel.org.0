Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE3F3A0CB3
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Jun 2021 08:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhFIGuv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Jun 2021 02:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhFIGuu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Jun 2021 02:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C09A1611C9;
        Wed,  9 Jun 2021 06:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623221336;
        bh=vhJXihDRzjK/SrpdSKLLYiiDtGzvXe+hkPB+Y8JfrwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ucPLIKqOmCXKBXoRnSJsXHhHjt9/jGcH+E6RBCrUix4iAvLUXa3HX8c5HfVPjMiAh
         99O5nIIgLkF9uj/lfE7N4XBvZ6KPMC14ZMy82+ZC1dfYAQ6SzdX682IBwVxxOtFGIq
         C1z0rxrPzuF/fFyhlBtvU4Kz/E8gxsPRf2dP6TS1Ri28+Vdn05CZG7oGStt0WNcgn3
         /J5YO8Ab4eKBkD2ijPxRK0hVYEh/D8kbTUbjPoHb3D0G+SpkedrEeLZ3QBc+cCjW33
         N2w6g+4WHrmcmdvs5qoYoXRHZsS7+a7d9GkhGFIW5D59dggpQ7tPudDlbkPSaFpYNs
         haD9RUif5o8rw==
Date:   Tue, 8 Jun 2021 23:48:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>
Subject: Re: [fsverity-utils PATCH 0/4] Add option to write Merkle tree to a
 file
Message-ID: <YMBkVyJQY6tzmReR@sol.localdomain>
References: <20210603195812.50838-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603195812.50838-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 03, 2021 at 12:58:08PM -0700, Eric Biggers wrote:
> Make 'fsverity digest' and 'fsverity sign' support writing the Merkle
> tree and fs-verity descriptor to files, using new options
> '--out-merkle-tree=FILE' and '--out-descriptor=FILE'.
> 
> Normally these new options aren't useful, but they can be needed in
> cases where the fs-verity metadata needs to be consumed by something
> other than one of the native Linux kernel implementations of fs-verity.
> 
> This is different from 'fsverity dump_metadata' in that
> 'fsverity dump_metadata' only works on a file with fs-verity enabled,
> whereas these new options are for the userspace file digest computation.
> 
> Supporting this required adding some optional callbacks to
> libfsverity_compute_digest().
> 
> Eric Biggers (4):
>   lib/compute_digest: add callbacks for getting the verity metadata
>   programs/test_compute_digest: test the metadata callbacks
>   programs/utils: add full_pwrite() and preallocate_file()
>   programs/fsverity: add --out-merkle-tree and --out-descriptor options
> 
>  include/libfsverity.h          |  46 +++++++++++-
>  lib/compute_digest.c           | 130 +++++++++++++++++++++++++++-----
>  programs/cmd_digest.c          |   7 +-
>  programs/cmd_sign.c            |  17 +++--
>  programs/fsverity.c            |  88 +++++++++++++++++++++-
>  programs/fsverity.h            |   4 +-
>  programs/test_compute_digest.c | 133 +++++++++++++++++++++++++++++++++
>  programs/utils.c               |  59 +++++++++++++++
>  programs/utils.h               |   3 +
>  9 files changed, 458 insertions(+), 29 deletions(-)
> 
> 
> base-commit: cf8fa5e5a7ac5b3b2dbfcc87e5dbd5f984c2d83a

All applied.

- Eric
