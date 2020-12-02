Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3D62CC4C6
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Dec 2020 19:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbgLBSNe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 13:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387885AbgLBSNd (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 13:13:33 -0500
Date:   Wed, 2 Dec 2020 10:12:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606932773;
        bh=EKhIwo7daUFW9jGZyPin9jtcHC0cCArGQF855Q4dIb4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=NrI4y3MQ0k724vSpYbAiU+Ai/IRTyWFuuUH/ImmdnmVxdNj3HeGbJHvSeltxiVcrb
         OvjPrx1nxJ95bdhi8xEsIyqwnsQ8a0ZqVWWtyVwSVvrcajNmwd8BzahKop1juh5B1V
         u+SShgIxx7O62dTMHz3NxqSlAxQDaibie9kdpXblZ1AOoX42S0+egIdL7iOR2EOGpp
         f4In5ZycjHg7U03HV39kWxLOOlyp0kOe2kMqlWZE9M47Qu7clZ7O9mueoVxPckXx9I
         XuLj1gzLeHh4mryIqPwJK3BD03uGAztP9ZqXzcXWKg6a9qrGrijbibzHFZ7wNB+mYy
         NyS88qh/scaQg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chris Mason <clm@fb.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: max fsverity descriptor size?
Message-ID: <X8fZI93Agr4f4Lwh@sol.localdomain>
References: <7F52BBF2-46A8-4854-9B68-1DC3EFA12EF0@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7F52BBF2-46A8-4854-9B68-1DC3EFA12EF0@fb.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

+linux-fscrypt

On Wed, Dec 02, 2020 at 09:01:52AM -0500, Chris Mason wrote:
> Hi Eric,
> 
> I’m working on fsverity support in btrfs and wanted to check on the max size
> of the descriptor.  I can go up to any size, just wanted to make sure I had
> things correct in the disk format.
> 
> -chris

The implementations of fs-verity in ext4 and f2fs store the built-in signature
(if there is one) appended to the 'struct fsverity_descriptor', and limit the
total size of those two things combined to 16384 bytes.  See
FS_VERITY_MAX_DESCRIPTOR_SIZE in fs/verity/fsverity_private.h.

Note that there's nothing special about this particular number; it's just an
implementation limit to prevent userspace doing weird things with megabytes
"signatures".

If btrfs will be storing built-in signatures in the same way, it probably should
use the same limit.  Preferably it would be done in a way such that it's
possible to increase the limit later if it's ever needed.

- Eric
