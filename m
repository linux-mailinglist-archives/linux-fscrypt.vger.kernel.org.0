Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF7470EB
	for <lists+linux-fscrypt@lfdr.de>; Sat, 15 Jun 2019 17:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfFOPbg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 15 Jun 2019 11:31:36 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60726 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726934AbfFOPbg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 15 Jun 2019 11:31:36 -0400
Received: from callcc.thunk.org (rrcs-74-87-88-165.west.biz.rr.com [74.87.88.165])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5FFVDgv011825
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 11:31:13 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CAC77420484; Sat, 15 Jun 2019 11:31:12 -0400 (EDT)
Date:   Sat, 15 Jun 2019 11:31:12 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-integrity@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4 14/16] ext4: add basic fs-verity support
Message-ID: <20190615153112.GO6142@mit.edu>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-15-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606155205.2872-15-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 06, 2019 at 08:52:03AM -0700, Eric Biggers wrote:
> +/*
> + * Format of ext4 verity xattr.  This points to the location of the verity
> + * descriptor within the file data rather than containing it directly because
> + * the verity descriptor *must* be encrypted when ext4 encryption is used.  But,
> + * ext4 encryption does not encrypt xattrs.
> + */
> +struct fsverity_descriptor_location {
> +	__le32 version;
> +	__le32 size;
> +	__le64 pos;
> +};

What's the benefit of storing the location in an xattr as opposed to
just keying it off the end of i_size, rounded up to next page size (or
64k) as I had suggested earlier?

Using an xattr burns xattr space, which is a limited resource, and it
adds some additional code complexity.  Does the benefits outweigh the
added complexity?

						- Ted
