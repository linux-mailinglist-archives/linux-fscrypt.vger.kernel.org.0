Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0FB2DD778
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 19:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbgLQSKC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 13:10:02 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47771 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731143AbgLQSKC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 13:10:02 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BHI8n91025024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 13:08:50 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CB08C420280; Thu, 17 Dec 2020 13:08:49 -0500 (EST)
Date:   Thu, 17 Dec 2020 13:08:49 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Satya Tangirala <satyat@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 0/3] add support for metadata encryption to F2FS
Message-ID: <X9uesUH1oetyyoA0@mit.edu>
References: <20201217150435.1505269-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217150435.1505269-1-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 03:04:32PM +0000, Satya Tangirala wrote:
> This patch series adds support for metadata encryption to F2FS using
> blk-crypto.

Is there a companion patch series needed so that f2fstools can
check/repair a file system with metadata encryption enabled?

	       	    	   	- Ted
