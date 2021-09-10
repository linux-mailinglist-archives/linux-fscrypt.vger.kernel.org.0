Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491C24073F2
	for <lists+linux-fscrypt@lfdr.de>; Sat, 11 Sep 2021 01:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhIJXeV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Sep 2021 19:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234883AbhIJXeA (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Sep 2021 19:34:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5503761213;
        Fri, 10 Sep 2021 23:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631316768;
        bh=UxYAz98NwSsIXqE3TUKUGodmHk57D6Vieot8raC5ZYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mu3+DEl5ryTOG0D28Nyg+gNmctTdngmd1o5792kxAHwJqMdZU5DffutL0GuDu38S8
         WhlAZB4rEIZfx3l81BDTAOMO2zAYsvPxphjmkKRrqfdyxEJt9UZ0uodKBO+xiz/WfA
         zUaRhhA1lPMWaLem8i8Im6U7IHp+K9Pf3NqCo2eKkPZPfKy6EGeD30bkiuz8GLa4sw
         wkgme0h4NwbMdBNHWZJIxpKOOMYnmlEknp2rgJXMIrgx4p+IRIE5HPpD4aAEaoG0oA
         sCGeHJviWiD0vneAeXz7+NoLyxO+AQuRh/2Dx6hDlZv/3e9uVD61WeRv2YdD+puP0e
         W1vThBj+YKHcg==
Date:   Fri, 10 Sep 2021 16:32:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 4/4] generic: test fs-verity EFBIG scenarios
Message-ID: <YTvrHnqnwm9cIzgN@sol.localdomain>
References: <cover.1620248200.git.boris@bur.io>
 <508058f805a45808764a477e9ad04353a841cf53.1620248200.git.boris@bur.io>
 <YK1c62bh1WQ/h45O@sol.localdomain>
 <YTvpsib6hrp/9ZPY@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTvpsib6hrp/9ZPY@zen>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Sep 10, 2021 at 04:26:42PM -0700, Boris Burkov wrote:
> 
> I am leaning towards making this a btrfs specific test. Just wanted to
> double check with you if you think ext4 and f2fs would benefit from
> running this test too..

It's applicable to ext4 and f2fs too, so it probably should be kept as a generic
test.  Just make sure that filesystems have to "opt in" to it (with a new
function _require_fsverity_max_file_size_limit() in common/verity or something),
since it's probably not going to be applicable to every filesystem that
implements fs-verity.

- Eric
