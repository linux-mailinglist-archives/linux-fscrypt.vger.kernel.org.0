Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8EECF2043
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Nov 2019 22:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfKFVCH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 6 Nov 2019 16:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfKFVCH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 6 Nov 2019 16:02:07 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D7D520663;
        Wed,  6 Nov 2019 21:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573074126;
        bh=l8HERbbYWwPxOaRBov0dAcNyxCTBMCsTgY5OdibAQoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t0Da7IX7qz9nNgwFVcIdj/QdkuUrTkitq+waVJeqOWI/cT+ucsM+vlZbrooJ8WDwK
         ncZUDZl7xxV/VKuq69TAjjjnRMBF8v/K92BUqhMF78G7y1yg78QmOb/EuyJZJxdJVu
         G9f9xzGKj8ybyscrNJUcPCJtK5Etb2tucmMIXjho=
Date:   Wed, 6 Nov 2019 13:02:05 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fscrypt: avoid data race on
 fscrypt_mode::logged_impl_name
Message-ID: <20191106210204.GA139580@gmail.com>
Mail-Followup-To: linux-fscrypt@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org
References: <20191021204903.56528-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021204903.56528-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 21, 2019 at 01:49:03PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The access to logged_impl_name is technically a data race, which tools
> like KCSAN could complain about in the future.  See:
> https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE
> 
> Fix by using xchg(), which also ensures that only one thread does the
> logging.
> 
> This also required switching from bool to int, to avoid a build error on
> the RISC-V architecture which doesn't implement xchg on bytes.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt.git#master for 5.5.

- Eric
