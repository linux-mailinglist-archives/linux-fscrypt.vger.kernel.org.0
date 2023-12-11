Return-Path: <linux-fscrypt+bounces-75-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A3880D278
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Dec 2023 17:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E8361F2160F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Dec 2023 16:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF30250F0;
	Mon, 11 Dec 2023 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="10U2V6iy"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356958E;
	Mon, 11 Dec 2023 08:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i2yTXhZ98lJELJnDUOhyYRgpOtbhX9CT8JLckwmAl/Q=; b=10U2V6iyB8Karqp48moMv+oDlg
	l0eo/emwTWSVjCKHM0HnG6FG1tVr0aO7ecr8t+QpTSRGEOoGVKIsOyJRo4jzeCkTmyqFyiSGTMpuq
	RqJ5VoSr4VCkhirUxDpqYooGk4lu+0d7J0ezL5UVI9XEnr1DHFP6rUyr/SLonlAbL6qnuUl6dYzco
	1Aa1wywcBTWg+5aIDDczv7K33DmN8LwkFC1LnVc/O91bJv5VwasPlyD6Ceib3UV0OG//e9Iamkk/Z
	kUQGsTa503UHT760y/I1zgoCWVM1nndt5wlI9NjinJNjIqkhS9gPFh4lT8yS3iTgB7J/2EbXOLpLY
	PiN9l6Aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjMe-005vGF-38;
	Mon, 11 Dec 2023 16:42:40 +0000
Date: Mon, 11 Dec 2023 08:42:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fscrypt@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] fscrypt: move the call to fscrypt_destroy_keyring() into
 ->put_super()
Message-ID: <ZXc8AISosHRDXMN7@infradead.org>
References: <20231206001325.13676-1-ebiggers@kernel.org>
 <ZXAW1BREPtCSUz4W@infradead.org>
 <20231206064430.GA41771@sol.localdomain>
 <ZXAf0WUbCccBn5QM@infradead.org>
 <20231209212938.GA2270@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231209212938.GA2270@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Dec 09, 2023 at 01:29:38PM -0800, Eric Biggers wrote:
> btrfs releases its block devices in ->put_super(), so with your proposal that
> would need to be moved to ->kill_sb() as well, right?

Yes.  I actually sent a patch for that in August:

   https://www.spinics.net/lists/linux-btrfs/msg138572.html

but it somehow got lost in the usual mess of btrfs trees and Dave
not wanting to Ack picking it up through the VFS tree with the rest
of the series.


