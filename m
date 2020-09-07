Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03582260708
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Sep 2020 00:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgIGWvR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Sep 2020 18:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgIGWvR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Sep 2020 18:51:17 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1737D2168B;
        Mon,  7 Sep 2020 22:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599519077;
        bh=saMragPdffCZPxQyLHxd+zI9kkNdGLq7NUZTmKci0zU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CYhamlPTjk5etSJmdJ8ZnIaDyEHNVSZMyagN8lWG/QP5naUJytebgFJFPPjCl7JCu
         RDk29CUfefjgHs47/liO50pOp8Wdp0euF3BJQ/I1ZYlQko22kW+LcQXwMtY7NhGVyx
         xPR5NoiKufWlT3O892PxvjEdlnibMPinuudGQql4=
Date:   Mon, 7 Sep 2020 15:51:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: drop unused inode argument from
 fscrypt_fname_alloc_buffer
Message-ID: <20200907225115.GB68127@sol.localdomain>
References: <20200810142139.487631-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810142139.487631-1-jlayton@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 10, 2020 at 10:21:39AM -0400, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/crypto/fname.c       | 5 +----
>  fs/crypto/hooks.c       | 2 +-
>  fs/ext4/dir.c           | 2 +-
>  fs/ext4/namei.c         | 7 +++----
>  fs/f2fs/dir.c           | 2 +-
>  fs/ubifs/dir.c          | 2 +-
>  include/linux/fscrypt.h | 5 ++---
>  7 files changed, 10 insertions(+), 15 deletions(-)
> 

Applied to fscrypt.git#master for 5.10.  Thanks!

- Eric
