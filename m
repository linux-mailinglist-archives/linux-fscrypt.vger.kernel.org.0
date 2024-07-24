Return-Path: <linux-fscrypt+bounces-362-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C13F93B4D8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2024 18:21:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29169283337
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2024 16:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F22215ECC2;
	Wed, 24 Jul 2024 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="pg3VmUUc"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEDC15ECC0
	for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jul 2024 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721838107; cv=none; b=LBo9Dj6ShztFUbdEJawrLzCa+yuDlpX5qmKEhDKS1Vk1VJ+0kAJ/hF+yAIA6Y65yZiO7uwEK4p7B9lYjNl+N7lmWxdR2HvMJKShsKEV4GuSqMlqQ3biJTV4JlZ22EA0/OGDrX1ZoWIaQmTHNbWe6uhx8mALTp/GZ3HwCECJ9FsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721838107; c=relaxed/simple;
	bh=vB9Yae19v7LUa5zWDxNrPhM5ExpUn167kiKlRJHhN/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPyWuh1emRGLWAkQ4tojTs+ZUm8fBu9M2SLOGSh0CT0CcX/cYeIAfDikRBOrxnVPeDf8M1auzJgB2D1NCCbqQGUubVMXXSbTzpbXv21Z4SNDFaNaQBAKkX6vLhQFGU7VPJUQ044L4KaFjmzXksKh5NuN8FFiSsK6yh0MemsIvEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=pg3VmUUc; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from cwcc.thunk.org (pool-173-48-113-198.bstnma.fios.verizon.net [173.48.113.198])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 46OGLWub017898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jul 2024 12:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1721838094; bh=ofF7hcycKI1A3je2myhR7t0W6v1DJnMOehPToQdbRyQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=pg3VmUUcM3zAFe/Nj5tA9Qy1lDlgmYnGrjVRjh/xX7yHcndBx7fqWjHenoKbfywT8
	 lUZbx54qpnqRnxYGF3A6F65zmF6zluUocXbvh2NXFYGBfcakvK5Pb5qEobO1aX7Vkj
	 xQjjcoWwWcze4wdM/rfoWfQ8AMSbWUVntpuae4JjaNiCwHtXZslF2p8DRChV76BMJJ
	 LVCR+/uffm6anG/f5HYtqRzCqdB/2pj9higN/B7uRUFWwyIAEHBqS+3UML7z8zhbpl
	 Bt+eLjzJi+gfQj6S9j+VMLL/easDK+EoR5l2rmOrPtgbpOdpq1Du5z1JrajZ+nZikO
	 ojwkAweMguM6A==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id CF2F915C0251; Wed, 24 Jul 2024 12:21:32 -0400 (EDT)
Date: Wed, 24 Jul 2024 12:21:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Yuvaraj Ranganathan <yrangana@qti.qualcomm.com>
Cc: "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Software encryption at fscrypt causing the filesystem access
 unresponsive
Message-ID: <20240724162132.GB131596@mit.edu>
References: <PH0PR02MB731916ECDB6C613665863B6CFFAA2@PH0PR02MB7319.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR02MB731916ECDB6C613665863B6CFFAA2@PH0PR02MB7319.namprd02.prod.outlook.com>

On Wed, Jul 24, 2024 at 02:21:26PM +0000, Yuvaraj Ranganathan wrote:
> Hello developers,
> 
> We are trying to validate a Software file based encryption with
> standard key by disabling Inline encryption and we are observing the
> adb session is hung.  We are not able to access the same filesystem
> at that moment.

The stack trace seems to indicate that the fast_commit feature is
enabled.  That's a relatively new feature; can you replicate the hang
without fast_commit being enabled?

						- Ted

