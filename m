Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6345667238
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jan 2023 13:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjALM3k (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Jan 2023 07:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjALM3j (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Jan 2023 07:29:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63126A46E;
        Thu, 12 Jan 2023 04:29:38 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CC7wSM018740;
        Thu, 12 Jan 2023 12:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=ZRtcTbFISDtOqBhzcR0sfvIsJVkfhCBtiM+lfEqS5+o=;
 b=Qm1fzKVF4PqQMfiLOuUCD7x0kFuN2xCS3gAs9TeV4MSPAJNj2bwGiIC3X7j+GZPn1/L1
 J48FZMVEK0mTf8kudHRvuYLeWDDFEk54fjsonWzu9DDVKeSni2BxIK5ICzy/xsO9lAQL
 H1MvgJOwG5RwJgLPtBIhRovWnM0Sq8QdAGWo/7MXzo8Bra23ITvV7Csgw9QZjwpfOmHk
 UmU2/4YblHSBc5jWY5O0lsm9UZlHE4ylvkEdDzFIXuzp5XN5MKfjJYS4+/pFDE3jY/Jn
 9EKs66PGkPqjgCRrPzU2/oqc9rNcuEKlxKoU4RNTxOrXawhXl+1ywM8jRRqA89Yh/HYT 8Q== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2hkbrsy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 12:29:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CBF1pi022366;
        Thu, 12 Jan 2023 12:29:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3n1k5u9tca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 12:29:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CCTPM546399834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 12:29:25 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FF3420043;
        Thu, 12 Jan 2023 12:29:25 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A72B2004B;
        Thu, 12 Jan 2023 12:29:24 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.109.253.169])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 12 Jan 2023 12:29:24 +0000 (GMT)
Date:   Thu, 12 Jan 2023 17:59:17 +0530
From:   Ojaswin Mujoo <ojaswin@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3] generic/692: generalize the test for non-4K Merkle
 tree block sizes
Message-ID: <Y7/9HchZqnS4Sd2S@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20230111205828.88310-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111205828.88310-1-ebiggers@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EeJ7gkEBHVckG5WO35JvoXzsVWcUaT5t
X-Proofpoint-GUID: EeJ7gkEBHVckG5WO35JvoXzsVWcUaT5t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_07,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jan 11, 2023 at 12:58:28PM -0800, Eric Biggers wrote:
> From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
> Due to the assumption of the Merkle tree block size being 4K, the file
> size calculated for the second test case was taking way too long to hit
> EFBIG in case of larger block sizes like 64K.  Fix this by generalizing
> the calculation to any Merkle tree block size >= 1K.
> 
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Co-developed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> v3: hashes_per_block, not hash_per_block
> v2: Cleaned up the original patch from Ojaswin:
>     - Explained the calculations as they are done.
>     - Considered 11 levels instead of 8, to account for 1K blocks
>       potentially needing up to 11 levels.
>     - Increased 'scale' for real number results, and don't use 'scale'
>       at all for integer number results.
>     - Improved a variable name.
>     - Updated commit message.
> 
>  tests/generic/692 | 37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/tests/generic/692 b/tests/generic/692
> index d6da734b..95f6ec04 100755
> --- a/tests/generic/692
> +++ b/tests/generic/692
> @@ -51,18 +51,31 @@ _fsv_enable $fsv_file |& _filter_scratch
>  #
>  # The Merkle tree is stored with the leaf node level (L0) last, but it is
>  # written first.  To get an interesting overflow, we need the maximum file size
> -# (MAX) to be in the middle of L0 -- ideally near the beginning of L0 so that we
> -# don't have to write many blocks before getting an error.
> -#
> -# With SHA-256 and 4K blocks, there are 128 hashes per block.  Thus, ignoring
> -# padding, L0 is 1/128 of the file size while the other levels in total are
> -# 1/128**2 + 1/128**3 + 1/128**4 + ... = 1/16256 of the file size.  So still
> -# ignoring padding, for L0 start exactly at MAX, the file size must be s such
> -# that s + s/16256 = MAX, i.e. s = MAX * (16256/16257).  Then to get a file size
> -# where MAX occurs *near* the start of L0 rather than *at* the start, we can
> -# just subtract an overestimate of the padding: 64K after the file contents,
> -# then 4K per level, where the consideration of 8 levels is sufficient.
> -sz=$(echo "scale=20; $max_sz * (16256/16257) - 65536 - 4096*8" | $BC -q | cut -d. -f1)
> +# ($max_sz) to be in the middle of L0 -- ideally near the beginning of L0 so
> +# that we don't have to write many blocks before getting an error.
> +
> +bs=$FSV_BLOCK_SIZE
> +hash_size=32   # SHA-256
> +hashes_per_block=$(echo "scale=30; $bs/$hash_size" | $BC -q)
> +
> +# Compute the proportion of the original file size that the non-leaf levels of
> +# the Merkle tree take up.  Ignoring padding, this is 1/($hashes_per_block^2) +
> +# 1/($hashes_per_block^3) + 1/($hashes_per_block^4) + ...  Compute it using the
> +# formula for the sum of a geometric series: \sum_{k=0}^{\infty} ar^k = a/(1-r).
> +a=$(echo "scale=30; 1/($hashes_per_block^2)" | $BC -q)
> +r=$(echo "scale=30; 1/$hashes_per_block" | $BC -q)
> +nonleaves_relative_size=$(echo "scale=30; $a/(1-$r)" | $BC -q)
> +
> +# Compute the original file size where the leaf level L0 starts at $max_sz.
> +# Padding is still ignored, so the real value is slightly smaller than this.
> +sz=$(echo "$max_sz/(1+$nonleaves_relative_size)" | $BC -q)
> +
> +# Finally, to get a file size where $max_sz occurs just after the start of L0
> +# rather than *at* the start of L0, subtract an overestimate of the padding: 64K
> +# after the file contents, then $bs per level for 11 levels.  11 levels is the
> +# most levels that can ever be needed, assuming the block size is at least 1K.
> +sz=$(echo "$sz - 65536 - $bs*11" | $BC -q)
> +
Hi Eric,

The comments look much better to me, thanks for the fix up. Tested on
powerpc with 64k and 4k tree sizes and the test passes fairly quickly so
patch looks good to me!
>  _fsv_scratch_begin_subtest "still too big: fail on first invalid merkle block"
>  truncate -s $sz $fsv_file
>  _fsv_enable $fsv_file |& _filter_scratch
> -- 
> 2.39.0
> 
