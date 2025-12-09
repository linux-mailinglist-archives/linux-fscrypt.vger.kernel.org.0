Return-Path: <linux-fscrypt+bounces-998-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7771FCB1390
	for <lists+linux-fscrypt@lfdr.de>; Tue, 09 Dec 2025 22:41:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8800A3105033
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Dec 2025 21:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE523115B5;
	Tue,  9 Dec 2025 21:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8JlOGxh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327F41A38F9;
	Tue,  9 Dec 2025 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765316470; cv=none; b=dDup49rN1otk6r5LBJjxjXI+dvp24jlR4QPAfcritXQQyr/EAaQ6tSXohgt0YhCtb3yNeOMfC8fUOX4EmzjIu7lebdFBl7QWiEt0tup7TcuMdKVB8ro3XYZNeWRJvGjptzWX68XP0oBCvhEGj5u3FvtnNo+MS4hO1zlGvb0EC7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765316470; c=relaxed/simple;
	bh=fdZLlRAP+Nvg9Zxz3D4x5l6oGEdPV4r9TIWov40uXWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2yaMKDBmHhDy8kIt5ePHaSiUATWscZ9Wnrw+6B2bRLl36rX7pzMQVb9I1t7K7MYvlxF8M/GLxVkBvtR5DI6Znrubz1gleoyfE16sKDjakDYSVroxXTnFQ89cpujfXeUTwzHOaKVmw+T17NHO+5ZC0VY5x77Eah8WgIPm2TMyJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8JlOGxh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C6AC4CEF5;
	Tue,  9 Dec 2025 21:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765316469;
	bh=fdZLlRAP+Nvg9Zxz3D4x5l6oGEdPV4r9TIWov40uXWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V8JlOGxhBggS7QSTRYBn5ZoPzUKR2lVWErQBUCQvdUNUb3TPcJ3QgpMwB+gRFj0Cy
	 wx/RT1aFPLPMHivjSxHtg4mXV0NhjJy7jfPrAzWNBExnIQpPOTjmHIsxjwqCHvKRMG
	 gzFGAXWT1WwCoPnbxPd+TC0/VApWbVq74NMx9yqDcHcEJ2uS+obLpJ0QixAoXWzAHV
	 dpW0Xbu0gPgUF/xCU5bAVjoAtRpQfntT2BBtf0/Lvrv4/zKhEklScjiY82e8ka05HT
	 oWzQ0n1SDjofp17TYiwLil62iJa8GR2p5zo9O5DP6cAa3X1iOdAJqAlvHj+XMy9T0v
	 53uDfuqLVZAnA==
Date: Tue, 9 Dec 2025 13:40:50 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: ext4/004 hangs with -o inlinecrypt,test_dummy_encryption
Message-ID: <20251209214050.GA7867@quark>
References: <aTZ3ahPop7q8O5cE@infradead.org>
 <80f77860-2d5d-4ff9-9bb8-1e5bc46a4692@bytedance.com>
 <dfb1479b-8aef-4f55-ba5b-4ae0595c4f99@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dfb1479b-8aef-4f55-ba5b-4ae0595c4f99@bytedance.com>

On Tue, Dec 09, 2025 at 05:46:22PM +0800, Julian Sun wrote:
> On 12/9/25 4:40 PM, Julian Sun wrote:
> > 
> > I can reproduce this issue locally with both v6.18 and v6.0. The problem
> > disappears after removing test_dummy_encryption, and it still reproduces
> > when test_dummy_encryption is set alone in MOUNT_OPTIONS. Therefore, I
> > believe the issue lies in test_dummy_encryption — it is an
> > implementation of fscrypt.
> > 
> > CC: linux-fscrypt
> > 
> > Thanks,
> 
> cc linux-fscrypt
> 
> -- 
> Julian Sun <sunjunchao@bytedance.com>
> 

It seems to be a known failure.  ext4/004, along with various other
tests, is excluded by
https://github.com/tytso/xfstests-bld/blob/master/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
as follows:

    ext4/004	// dump/restore doesn't handle quotas

I'm not sure why the comment mentions quotas.  It probably should say
"encryption", not "quotas".

Either way, the exclusion logic in xfstests-bld really should be
incorporated directly into xfstests, e.g. by using
_exclude_test_mount_option "test_dummy_encryption".

This seems to be a wider issue.  Effectively, ext4's exclusion lists for
xfstests are being maintained outside of xfstests itself.

- Eric

